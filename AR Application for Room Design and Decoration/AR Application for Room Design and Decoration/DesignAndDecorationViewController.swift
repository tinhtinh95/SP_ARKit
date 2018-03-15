import UIKit
import SceneKit
import ARKit

class DesignAndDecorationViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let contentRootNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        contentRootNode.isHidden=true
        addTapGestureToSceneView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection=[.horizontal,.vertical]
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - Gesture Recognizers
    
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        let panGestureRecognizer=UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        let viewRotatedGestureRecognizer=UIRotationGestureRecognizer(target: self, action: #selector(viewRotated(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        sceneView.addGestureRecognizer(panGestureRecognizer)
        sceneView.addGestureRecognizer(viewRotatedGestureRecognizer)
    }
    
    @objc func didTap(_ recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        // When tapped on the object, call the object's method to react on it
        let sceneHitTestResult = sceneView.hitTest(location, options: nil)
        if !sceneHitTestResult.isEmpty {
            // We only have one content, so we know which node was hit.
            // If the scene contains multiple objects, you would need to check here if the right node was hit
            print("you hit it")
            return
        }
        // When tapped on a plane, reposition the content
        let arHitTestResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if !arHitTestResult.isEmpty {
            let hit = arHitTestResult.first!
            sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
                if node.name=="first" {
                    node.removeFromParentNode()
                }
            }
            print("you hit outside node")
            let newLocation = SCNVector3(x: hit.worldTransform.columns.3.x, y: hit.worldTransform.columns.3.y, z: hit.worldTransform.columns.3.z)
            let boxNode = addBox()
            boxNode.position = newLocation
            boxNode.name="first"
            sceneView.scene.rootNode.addChildNode(boxNode)
        }
    }
    
    @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        // Drag the object on an infinite plane
        let arHitTestResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if !arHitTestResult.isEmpty {
            let hit = arHitTestResult.first!
            sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
                if node.name=="first" {
                    node.removeFromParentNode()
                }
            }
            let newLocation = SCNVector3(x: hit.worldTransform.columns.3.x, y: hit.worldTransform.columns.3.y, z: hit.worldTransform.columns.3.z)
            let boxNode = addBox()
            boxNode.position = newLocation
            boxNode.name="first"
            sceneView.scene.rootNode.addChildNode(boxNode)
            
            //                if recognizer.state == .ended {
            //                   print(recognizer.state)
            //                }
        }
    }
    
    var originalRotation: SCNVector3?
    
    @objc func viewRotated(_ recognizer: UIRotationGestureRecognizer) {
        print("viewRotated")
        let location = recognizer.location(in: sceneView)
        // When tapped on the object, call the object's method to react on it
        let sceneHitTestResult = sceneView.hitTest(location, options: nil)
        if !sceneHitTestResult.isEmpty {
            switch recognizer.state {
            case .began:
                sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
                    if node.name=="first" {
                        originalRotation = node.eulerAngles
                    }
                }
            case .changed:
                guard var originalRotation = originalRotation else { return }
                originalRotation.y -= Float(recognizer.rotation)
                sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
                    if node.name=="first" {
                        node.eulerAngles = originalRotation
                    }
                }
                
            default:
                originalRotation = nil
            }
        }
    }
    
    
    func addBox()->SCNNode{
        //        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        //        let boxNode = SCNNode()
        //        boxNode.geometry = box
        //        return boxNode
        let node = SCNNode()
        let scene = SCNScene(named: "cup.scn")
        let nodeArray = scene?.rootNode.childNodes
        for childNode in nodeArray! {
            node.addChildNode(childNode as SCNNode)
        }
        
        return node
    }
    
    
    
    
}
