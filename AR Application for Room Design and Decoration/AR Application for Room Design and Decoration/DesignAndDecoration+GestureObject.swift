import UIKit
import SceneKit
import ARKit

extension DesignAndDecorationViewController {
    
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tapGestureRecognizer.numberOfTapsRequired=2
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        let panGestureRecognizer=UIPanGestureRecognizer(target: self, action: #selector(move(_:)))
        panGestureRecognizer.maximumNumberOfTouches=1
        sceneView.addGestureRecognizer(panGestureRecognizer)
        let viewRotatedGestureRecognizer=UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        sceneView.addGestureRecognizer(viewRotatedGestureRecognizer)
        let pinGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scale(_:)))
        sceneView.addGestureRecognizer(pinGestureRecognizer)
    }
    
    @objc func tap(_ recognizer: UIGestureRecognizer) {
        closeAllAnimation()
        
        let location = recognizer.location(in: sceneView)
        guard let selectedNode = getNodeRelatedRootNode(at: location) as SCNNode? else { return }
        
        let arHitTestResult = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])
        
        if !arHitTestResult.isEmpty {
            if deleteNode == nil{
                DispatchQueue.main.async {
                    let transform = arHitTestResult.first?.worldTransform
                    self.positionTmp=transform!
                    let newPosition = float3((transform?.columns.3.x)!, ((transform?.columns.3.y)!+0.1), (transform?.columns.3.z)!)
                    selectedNode.simdPosition = newPosition
                    self.sceneView.scene.rootNode.addChildNode(selectedNode)
                    self.deleteNode=selectedNode
                    self.toggleShowButton(true)
                }
            }else{
                if selectedNode == deleteNode{
                    DispatchQueue.main.async {
                        let transform = self.positionTmp
                        let newPosition = float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                        selectedNode.simdPosition = newPosition
                        self.sceneView.scene.rootNode.addChildNode(selectedNode)
                        self.deleteNode=nil
                        self.toggleShowButton(false)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        
                        let transform = self.positionTmp
                        let oldPosition = float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                        
                        self.deleteNode?.simdPosition = oldPosition
                        self.sceneView.scene.rootNode.addChildNode(self.deleteNode!)
                        
                        let transformNew = arHitTestResult.first?.worldTransform
                        self.positionTmp=transformNew!
                        let newPosition = float3((transformNew?.columns.3.x)!, ((transformNew?.columns.3.y)!+0.1), (transformNew?.columns.3.z)!)
                        selectedNode.simdPosition = newPosition
                        self.sceneView.scene.rootNode.addChildNode(selectedNode)
                        self.toggleShowButton(true)
                        self.deleteNode=selectedNode
                    }
                }
            }
        }
    }
    
    @objc func move(_ recognizer: UIPanGestureRecognizer) {
        closeAllAnimation()
        
        let translation = recognizer.translation(in: sceneView)
        recognizer.setTranslation(.zero, in: sceneView)
        
        let location = recognizer.location(in: sceneView)
        guard let selectedNode = getNodeRelatedRootNode(at: location) as SCNNode? else { return }
        
        let hitTestResults = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])
        
        for infinitePlaneResult in hitTestResults {
//            if let planeAnchor = infinitePlaneResult.anchor as? ARPlaneAnchor{
//                if planeAnchor.alignment != .vertical {
                    let currentPositionInRederedScreen = CGPoint(sceneView.projectPoint(selectedNode.position))
                    let zDepth=sceneView.projectPoint(selectedNode.position).z
                    let nextPositionInRederedScreen = CGPoint(x: currentPositionInRederedScreen.x + translation.x, y: currentPositionInRederedScreen.y + translation.y)
                    let hitTestResults1 = sceneView.hitTest(nextPositionInRederedScreen, types: [.existingPlaneUsingExtent])
                    if !hitTestResults1.isEmpty {
                        selectedNode.position = sceneView.unprojectPoint(SCNVector3(nextPositionInRederedScreen.x, nextPositionInRederedScreen.y, CGFloat(zDepth)))
//                    }
//                }
            }

        }
    }
    
    @objc func rotate(_ recognizer: UIRotationGestureRecognizer) {
        closeAllAnimation()
        
        let location = recognizer.location(in: sceneView)
        guard let selectedNode = getNodeRelatedRootNode(at: location) as SCNNode? else { return }
//        print(Float(recognizer.rotation))
        if selectedNode.eulerAngles.x != 0 && selectedNode.eulerAngles.z != 0 {
            for childNode in selectedNode.childNodes{
                print(childNode.eulerAngles)
                childNode.eulerAngles.y -= Float(recognizer.rotation)
            }
        }
        else{
            selectedNode.eulerAngles.y -= Float(recognizer.rotation)
        }

        recognizer.rotation = 0
    }
    

    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        guard let node = getNodeRelatedRootNode(at: location) else{return}
        switch gesture.state {
        case .began:
            gesture.scale = CGFloat(node.scale.x)
        case .changed:
            if gesture.scale > 2.0 || gesture.scale < 0.5 {
                return
            }
            node.scale = SCNVector3(Float(gesture.scale),Float(gesture.scale),Float(gesture.scale))
        default:
            gesture.scale = 1.0
        }
    }
    
    private func getNodeRelatedRootNode(at location: CGPoint) -> SCNNode? {
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        //Search all objects
        hitTestOptions[SCNHitTestOption.searchMode] = 1
        
        let results = sceneView.hitTest(location, options: hitTestOptions)
        for result in results {
            if result.node.name != "planeNode" && result.node.name != nil {
                var nodeRelatedRootNode = result.node
                while true{
                    if nodeRelatedRootNode.parent == sceneView.scene.rootNode{
                        return nodeRelatedRootNode
                    }
                    nodeRelatedRootNode = nodeRelatedRootNode.parent!
                }
            }
        }
        return nil
    }
    
    func toggleShowButton(_ check: Bool){
        self.btnTakeScreen.isHidden=check
        self.btnDelete.isHidden=(!check)
        self.btnMenu.isHidden=check
        self.menuView.isHidden=check
        self.btnOption.isHidden=check
    }
}

extension CGPoint {
    /// Extracts the screen space point from a vector returned by SCNView.projectPoint(_:).
    init(_ vector: SCNVector3) {
        self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }
    
    /// Returns the length of a point when considered as a vector. (Used with gesture recognizers.)
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
}
extension float4x4 {
    /**
     Treats matrix as a (right-hand column-major convention) transform matrix
     and factors out the translation component of the transform.
     */
    var translation: float3 {
        get {
            let translation = columns.3
            return float3(translation.x, translation.y, translation.z)
        }
        set(newValue) {
            columns.3 = float4(newValue.x, newValue.y, newValue.z, columns.3.w)
        }
    }
  
}


