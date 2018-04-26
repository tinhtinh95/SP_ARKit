import UIKit
import SceneKit
import ARKit
import SceneKitVideoRecorder

 var ID:Int = 0

class DesignAndDecorationViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, DesignAndDecorationDelegate, UIGestureRecognizerDelegate{
    
    func putItem(itemPath: String, id: Int) {
        print("Value recieved from ItemViewController: " + itemPath)
        print(id)
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
//        var checkID: Int=TableFurnitureViewController.arrListItem[id]
        
        var scene=SCNScene(named: "art.scnassets/vase/vase.scn")
        if id==0{
            scene = SCNScene(named: "art.scnassets/TableLamp/TableLamp.scn")
        }else if id==1{
            scene = SCNScene(named: "art.scnassets/DesignSofa/3Dmodels/DesignSofa1.scn")
        }else if id==4{
            scene = SCNScene(named: "art.scnassets/chair/chair.scn")
        }
        
        
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

        closeMenu()
        btnMenu.transform = .identity
    }
    
    @IBOutlet weak var menuView: UIViewX!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnTakeScreen: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnOption: UIButton!

    @IBOutlet weak var optionView: UIView!
    
    @IBOutlet weak var btnTable: UIButtonX!
    @IBOutlet weak var btnChair: UIButtonX!
    @IBOutlet weak var btnShelf: UIButtonX!
    @IBOutlet weak var btnLamp: UIButtonX!
    @IBOutlet weak var btnDesk: UIButtonX!
    @IBOutlet weak var btnWardore: UIButtonX!
    @IBOutlet weak var btnBed: UIButtonX!
    @IBOutlet weak var btnSofa: UIButtonX!
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var swtAudio: UISwitch!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var isRecord: UIButton!
    @IBOutlet weak var isPlay: UIButton!
    
    // planes
    var dictPlanes = [ARPlaneAnchor: Plane]()
    //    var sceneLight:SCNLight!
    var deleteNode : SCNNode!
    var positionTmp=matrix_float4x4()
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    var originalRotation: SCNVector3?
    
    var recorder: SceneKitVideoRecorder?
    var isVideo: Bool!
    var pathVideo: URL!
    var originalScale:SCNVector3?
   
    
    var selectedObject: SCNNode?
    
    /// The object that is tracked for use by the pan and rotation gestures.
    var trackedObject: SCNNode? {
        didSet {
            guard trackedObject != nil else { return }
            selectedObject = trackedObject
        }
    }
    var x: Float!
    var z: Float!
    
    var currentTrackingPosition: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        // environment change make objects are not changed
        sceneView.automaticallyUpdatesLighting = false
        // control gesture: tap, drag and rotate
        addTapGestureToSceneView()
        // set default for menu view and option view
        closeMenu()
        closeOption()
        
        btnSofa.tag = 0
        btnBed.tag = 1
        btnWardore.tag = 2
        btnDesk.tag = 3
        btnLamp.tag = 4
        btnShelf.tag = 5
        btnChair.tag = 6
        btnTable.tag = 7
        
        recorder = try! SceneKitVideoRecorder(withARSCNView: sceneView)
        navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection=[.horizontal,.vertical]
        // Run the view's session
        sceneView.session.run(configuration)
        configuration.isLightEstimationEnabled = true
        configuration.worldAlignment = .gravityAndHeading
      sceneView.debugOptions=[ARSCNDebugOptions.showFeaturePoints]
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

    // When tap background -> close all
    @IBAction func tapBackground(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.closeMenu()
            self.btnMenu.transform = .identity
            self.closeOption()
            self.btnOption.transform = .identity
        })
    }
    
    // Action for menu -> rotation menu button and show menu view
    @IBAction func menuTapper(_ sender: FloatingActionButton) {
            UIView.animate(withDuration: 0.3, animations: {
                if self.menuView.transform == .identity{
                    self.closeMenu()
                } else {
                    self.closeOption()
                    self.menuView.transform = .identity
                }
            })
        
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            if self.menuView.transform == .identity {
                self.btnTable.transform = .identity
                self.btnChair.transform = .identity
                self.btnShelf.transform = .identity
                self.btnLamp.transform = .identity
                self.btnDesk.transform = .identity
                self.btnWardore.transform = .identity
                self.btnBed.transform = .identity
                self.btnSofa.transform = .identity
            }
        })
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
        
        let button = sender as! UIButtonX
        let destination = storyboard?.instantiateViewController(withIdentifier: "TableFurniture") as! TableFurnitureViewController
        
        destination.delegate = self
        present(destination, animated: true, completion: nil)
//        self.navigationController?.present(destination, animated: true, completion: nil)
        
        ID = button.tag
    }
    
    // Action for option -> rotation option button and show option view
    @IBAction func optionTapper(_ sender: OptionActionButton) {
        UIView.animate(withDuration: 0.3, animations: {
            
            // if menu is opening -> close menu
            self.closeMenu()
            self.btnMenu.transform = .identity
            
            if self.optionView.transform == .identity{
                self.closeOption()
            } else {
                self.optionView.transform = .identity
            }
        })
    }
    
    
    //Animation buttons in menu view
    func closeMenu(){
        self.menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        btnTable.transform = CGAffineTransform(translationX: -6, y: 0)
        btnChair.transform = CGAffineTransform(translationX: -6, y: -2)
        btnShelf.transform = CGAffineTransform(translationX: -6, y: -5)
        btnLamp.transform = CGAffineTransform(translationX: 0, y: -6)
        btnDesk.transform = CGAffineTransform(translationX: 0, y: -6)
        btnWardore.transform = CGAffineTransform(translationX: 6, y: -5)
        btnBed.transform = CGAffineTransform(translationX: 6, y: -2)
        btnSofa.transform = CGAffineTransform(translationX: 6, y: 0)
        
    }
    
    // Close option
    func closeOption(){
        self.optionView.transform = CGAffineTransform(translationX: 0 , y: 400)
    }
    
    // 
    @IBAction func returned(segue: UIStoryboardSegue) {
        closeMenu()
        btnMenu.transform = .identity
    }

}


