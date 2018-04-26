import ARKit
import AVFoundation
import AVKit

extension DesignAndDecorationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBAction func chooseCup(_ location:SCNVector3){
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if node.name == "planeNode"{
                node.removeFromParentNode()
            }
        }

        let hit = sceneView.hitTest(view.center, types: .existingPlaneUsingExtent)
        if hit.isEmpty{
            return
        }
        let node = SCNNode()
        let wrappNode=SCNNode()
        let scene = SCNScene(named: "art.scnassets/cup.scn")
        let nodeArray = scene?.rootNode.childNodes
        for childNode in nodeArray! {
            wrappNode.addChildNode(childNode)
        }
        node.addChildNode(wrappNode)
//        node.scale=SCNVector3(0.05,0.05,0.05)
        let results=hit.first?.worldTransform
        node.position=SCNVector3((results?.columns.3.x)!, (results?.columns.3.y)!, (results?.columns.3.z)!)
        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.addChildNode(node)
            if self.swtAudio.isOn{
               self.audioConfigure(action: "add")
            }
        }
        self.closeMenu()
        UIView.animate(withDuration: 0.3, animations: {self.btnMenu.transform = .identity})
    }

    @IBAction func choose(sender: UIButton){
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if node.name == "planeNode"{
                node.removeFromParentNode()
            }
        }

        let hit = sceneView.hitTest(view.center, types: .existingPlaneUsingExtent)
        if hit.isEmpty{
            return
        }
        let node = SCNNode()
        let myURL = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/realmdemo-25a4e.appspot.com/o/scnFiles%2Fcup.scn?alt=media&token=3d1d0a5f-9e35-41e2-9c7f-1b001c13d6e0")
        let scene = try! SCNScene(url: myURL! as URL, options: nil)
        let nodeArray = scene.rootNode.childNodes
        for childNode in nodeArray {
            node.addChildNode(childNode)
        }
//        node.scale = SCNVector3(0.01,0.01,0.01)

        let results=hit.first?.worldTransform
        node.position=SCNVector3((results?.columns.3.x)!, (results?.columns.3.y)!, (results?.columns.3.z)!)
//        self.sceneView.scene.rootNode.addChildNode(node)


        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.addChildNode(node)
            if self.swtAudio.isOn{
                self.audioConfigure(action: "add")
            }
        }
        self.closeMenu()
        UIView.animate(withDuration: 0.3, animations: {self.btnMenu.transform = .identity})
    }
    
    func audioConfigure(action:String){
        // configure audio
        do{
            var audio=""
            if action=="add"{
                audio=Bundle.main.path(forResource: "add", ofType: "mp3")!
            }else{
                audio=Bundle.main.path(forResource: "delete", ofType: "mp3")!
            }
            audioPlayer = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audio) as URL)
            audioPlayer.play()
        }catch{

        }
    }

    @IBAction func btnDeleteEvent() {
        // create the alert
        let alert = UIAlertController(title: "Warning!", message: "Do you want to remove it?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{
            (action) -> Void in
            DispatchQueue.main.async {
                self.deleteNode.removeFromParentNode()
                if self.swtAudio.isOn{
                    self.audioConfigure(action: "delete")
                }
                self.deleteNode=nil
                self.toggleShowButton(false)
            }
        }
        ))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func btnTakeScreendEvent() {
        closeAllAnimation()
        let image = sceneView.snapshot()
        print("Information: ", image)
        imgView.isHidden=false
        imgView.image=image
        btnCancel.isHidden=false
        btnShare.isHidden=false
        isVideo=false
        
        let imageData: Data = UIImageJPEGRepresentation(image, 0.50)!
        let imageSave=ImageSave(imageData)
        RealmService.shared.create(imageSave)
    }
    @IBAction func btnShareEvent() {
        let image = imgView.image
        if !btnShare.isHidden{
            if isVideo{
                let activity=UIActivityViewController(activityItems: [pathVideo], applicationActivities: nil)
                activity.popoverPresentationController?.sourceView=self.view
                self.present(activity, animated: true, completion: nil)
            }
            else{
                let activity=UIActivityViewController(activityItems: [image ?? ""], applicationActivities: nil)
                activity.popoverPresentationController?.sourceView=self.view
                self.present(activity, animated: true, completion: nil)
            }
        }
    }
    @IBAction func btnCancelEvent() {
        if !btnCancel.isHidden{
            imgView.isHidden=true
            btnCancel.isHidden=true
            btnShare.isHidden=true
            isPlay.isHidden=true
            btnTakeScreen.isHidden=false
        }
    }
    
    @IBAction func btnResetEvent(){
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            node.removeFromParentNode()
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        btnMenu.isHidden=true
        menuView.isHidden=true
        UIView.animate(withDuration: 0.3, animations: {
            self.closeMenu()
            self.btnMenu.transform = .identity
            self.closeOption()
            self.btnOption.transform = .identity
        })
    }
    
    
    @IBAction func startRecord(sender: UIButton){
        isRecord.isHidden=false
        btnTakeScreen.isHidden=true
        UIView.animate(withDuration: 0.3, animations: {
            self.closeMenu()
            self.btnMenu.transform = .identity
            self.closeOption()
            self.btnOption.transform = .identity
        })
        self.recorder?.startWriting().onSuccess {
            print("Recording Started")
        }
    }
    
    @IBAction func stopRecord(sender: UIButton){
        self.recorder?.finishWriting().onSuccess { [weak self] url in
            print("Recording Finished", url)
            self?.pathVideo=url
            self?.isVideo=true
            self?.isPlay.isHidden=false
            self?.isRecord.isHidden=true
            let image = self?.sceneView.snapshot()
            self?.imgView.image=image
            self?.imgView.isHidden=false
            self?.btnCancel.isHidden=false
            self?.btnShare.isHidden=false
            
            do{
                let videoData = try! Data(contentsOf: url as URL)
                let videoSave=ImageSave(videoData)
                RealmService.shared.create(videoSave)
            }catch{
                print("err")
            }

        }
    }
    
    @IBAction func playVideo(sender: UIButton){
        if !isPlay.isHidden{
            self.playVideoAsFullScreen()
        }
    }
    
    func playVideoAsFullScreen(){
        let player = AVPlayer(url: pathVideo)
        let playerController = AVPlayerViewController()
        playerController.player = player
        player.play()
        self.present(playerController, animated: true) {}
    }

    func closeAllAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.closeMenu()
            self.btnMenu.transform = .identity
            self.closeOption()
            self.btnOption.transform = .identity
        })
    }
}

