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
        sceneView.debugOptions = []
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // create plane with the "PlaneAnchor"
                let plane = Plane(anchor: planeAnchor)
                // add to the detected
                node.addChildNode(plane)
                self.lbSearchPlane.text = "Plane is detected"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.lbSearchPlane.isHidden = true
                })
                self.lbSearchPlane.textColor = UIColor.orange
                // add to dictionary
                self.dictPlanes[planeAnchor] = plane
            }
            self.menuView.isHidden=false
            self.btnMenu.isHidden=false
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // get plane with anchor
                let plane = self.dictPlanes[planeAnchor]
                // update
                plane?.updateAnchor(planeAnchor)
            }
        }
        
    }
 
}
