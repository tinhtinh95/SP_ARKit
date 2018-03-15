import ARKit
import SceneKit

extension DesignAndDecorationViewController{
    var session: ARSession {
        return sceneView.session
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // If light estimation is enabled, update the intensity of the model's lights and the environment map
        let baseIntensity: CGFloat = 40
        let lightingEnvironment = sceneView.scene.lightingEnvironment
        if let lightEstimate = session.currentFrame?.lightEstimate {
            lightingEnvironment.intensity = lightEstimate.ambientIntensity / baseIntensity
        } else {
            lightingEnvironment.intensity = baseIntensity
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !contentRootNode.isHidden {
            return
        }
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            print("Can't find plane")
            return
        }
        print("Plane Anchor with extent:", planeAnchor.extent)
        
        if anchor is ARPlaneAnchor {
            //            let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            //            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            //
            //            let planeNode = SCNNode(geometry: planeGeometry)
            //            planeNode.position = SCNVector3(x: planeAnchor.center.x, y:0, z: planeAnchor.center.z)
            //            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            //            //            updateMaterial()
            //
            //            node.addChildNode(planeNode)
            
            let boxNode=addBox()
            boxNode.name="first"
            boxNode.position=SCNVector3(x: planeAnchor.center.x, y:0, z: planeAnchor.center.z)
//            contentRootNode.addChildNode(boxNode)
            node.addChildNode(boxNode)
            contentRootNode.isHidden=false
//            anchor.identifier =
            
            //            anchors.append(planeAnchor)
            
            
        }
        
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {
//            print("Can't find plane")
//            return
//        }
//        print("Plane Anchor with update extent:", planeAnchor.extent)

    }
    
    
}



