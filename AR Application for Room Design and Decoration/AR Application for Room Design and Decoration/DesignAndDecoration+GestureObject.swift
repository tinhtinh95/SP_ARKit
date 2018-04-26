import UIKit
import SceneKit
import ARKit

extension DesignAndDecorationViewController {

    
    // MARK: - Gesture Recognizers
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired=2
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        let panGestureRecognizer=UIPanGestureRecognizer(target: self, action: #selector(didMove(_:)))
        panGestureRecognizer.maximumNumberOfTouches=1
        sceneView.addGestureRecognizer(panGestureRecognizer)
        let viewRotatedGestureRecognizer=UIRotationGestureRecognizer(target: self, action: #selector(didRotated(_:)))
        sceneView.addGestureRecognizer(viewRotatedGestureRecognizer)
        let pinGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scale(_:)))
        sceneView.addGestureRecognizer(pinGestureRecognizer)
    }

    @objc func didTap(_ recognizer: UIGestureRecognizer) {
       closeAllAnimation()
        let location = recognizer.location(in: sceneView)
        let hit = node(at: location)
//        if hit.isEmpty{
//            return
//        }
        // return if not tap 3D models
        if hit?.name=="planeNode" || hit?.name==nil{
            return
        }
            // Check the plane behind the node
            let arHitTestResult = sceneView.hitTest(location, types:
                [.existingPlaneUsingGeometry,.estimatedVerticalPlane,.estimatedHorizontalPlane,.existingPlane,.existingPlaneUsingExtent,.featurePoint,]
        )
            if !arHitTestResult.isEmpty {
                print("You're hit the node")
                let selectedNode=(hit?.parent)
                if deleteNode==nil{
                    DispatchQueue.main.async {
                        let transform = arHitTestResult.first?.worldTransform
                        self.positionTmp=transform!
                        let newPosition = float3((transform?.columns.3.x)!, ((transform?.columns.3.y)!+0.1), (transform?.columns.3.z)!)
                        selectedNode?.simdPosition = newPosition
                        self.sceneView.scene.rootNode.addChildNode(selectedNode!)
//                        self.sceneView.backgroundColor=UIColor.white
                        self.deleteNode=selectedNode!
                        self.toggleShowButton(true)
                    }
                }else{
                    if selectedNode == deleteNode{
                        DispatchQueue.main.async {
                            let transform = self.positionTmp
                            let newPosition = float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                            selectedNode?.simdPosition = newPosition
                            self.sceneView.scene.rootNode.addChildNode(selectedNode!)
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
                            selectedNode?.simdPosition = newPosition
                            self.sceneView.scene.rootNode.addChildNode(selectedNode!)
                            self.toggleShowButton(true)
                            self.deleteNode=selectedNode!
                        }
                    }
                }
        }
    }

    @objc func didMove(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .changed{
            
            let translation = recognizer.translation(in: sceneView)
            
            recognizer.setTranslation(.zero, in: sceneView)
            
            closeAllAnimation()
            let location = recognizer.location(in: sceneView)
            let hit=sceneView.hitTest(location, options: nil).first
            if hit?.node.name=="planeNode" || hit?.node.name==nil{
                return
            }
            
            let arHitTestResult = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])
            
            if !arHitTestResult.isEmpty {
                guard var selectedNode=(hit?.node) as SCNNode? else { return }
                while true {
                    if selectedNode.parent == sceneView.scene.rootNode {
                        print("OK MAN")
                        break
                    }
                    selectedNode = selectedNode.parent!
                }
                print(selectedNode.position)
                var currentPosition = CGPoint(sceneView.projectPoint(selectedNode.position))
                currentPosition = CGPoint(x: currentPosition.x + translation.x, y: currentPosition.y + translation.y)
                
                let arHitTestResult1 = sceneView.hitTest(currentPosition, types: [.existingPlaneUsingExtent])
                
                if arHitTestResult1.isEmpty{
                    return
                }
                
                let worldTransform = arHitTestResult1.first?.worldTransform
                let newPosition = SCNVector3((worldTransform?.columns.3.x)!,(worldTransform?.columns.3.y)!,(worldTransform?.columns.3.z)!)
                selectedNode.position = newPosition
                sceneView.scene.rootNode.addChildNode(selectedNode)
            }
            
        }
    }
    @objc func didRotated(_ recognizer: UIRotationGestureRecognizer) {
       closeAllAnimation()
        let location = recognizer.location(in: sceneView)
        let hit = node(at: location)
        // Check name if it is planeNode (doesn't remove)
        if hit?.name=="planeNode" || hit?.name==nil{
            return
        }

        // When tapped on the object, call the object's method to react on it
        let sceneHitTestResult = sceneView.hitTest(location, types: [.existingPlaneUsingGeometry,.estimatedVerticalPlane,.estimatedHorizontalPlane,.existingPlane,.existingPlaneUsingExtent,.featurePoint])
        if !sceneHitTestResult.isEmpty {
            guard let selectedNode=(hit?.parent) as SCNNode? else { return }
            print("This node is rotating")
            switch recognizer.state {
            case .began:
                self.originalRotation = selectedNode.eulerAngles
            case .changed:
                guard var originalRotationTmp = self.originalRotation else { return }
                originalRotationTmp.y -= Float(recognizer.rotation)
                selectedNode.eulerAngles = originalRotationTmp
            default:
                self.originalRotation = nil
            }
        }
    }
    private func node(at position: CGPoint) -> SCNNode? {
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        return (sceneView.hitTest(position, options: hitTestOptions).first?.node)
        
        
    }
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        guard let node = node(at: location)?.parent else{return}
        switch gesture.state {
        case .began:
            self.originalScale = node.scale
            gesture.scale = CGFloat(node.scale.x)
        case .changed:
            guard var originalScale = self.originalScale else { return }
            if gesture.scale > 2.0{
                return
            }
            originalScale.x = Float(gesture.scale)
            originalScale.y = Float(gesture.scale)
            originalScale.z = Float(gesture.scale)
            node.scale = originalScale
        case .ended:
            guard var originalScale = self.originalScale else { return }
            if gesture.scale > 2.0{
                return
            }
            originalScale.x = Float(gesture.scale)
            originalScale.y = Float(gesture.scale)
            originalScale.z = Float(gesture.scale)
            node.scale = originalScale
            gesture.scale = CGFloat(node.scale.x)
            
        default:
            gesture.scale = 1.0
            self.originalScale = nil
        }
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

    /**
     Factors out the orientation component of the transform.
     */
    var orientation: simd_quatf {
        return simd_quaternion(self)
    }

    /**
     Creates a transform matrix with a uniform scale factor in all directions.
     */
    init(uniformScale scale: Float) {
        self = matrix_identity_float4x4
        columns.0.x = scale
        columns.1.y = scale
        columns.2.z = scale
    }
}


