import UIKit
import SceneKit
import ARKit
import SceneKitVideoRecorder
import RealmSwift

var ID:Int = 0

class DesignAndDecorationViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, DesignAndDecorationDelegate, UIGestureRecognizerDelegate{
    
    var fileManager = FileManager.default
    @IBOutlet weak var menuView: UIViewX!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnTakeScreen: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnOption: UIButton!
    
    @IBOutlet weak var optionView: UIView!
    
    @IBOutlet weak var btnWardrobe: UIButtonX!
    @IBOutlet weak var btnTable: UIButtonX!
    @IBOutlet weak var btnPicture: UIButtonX!
    @IBOutlet weak var btnLamp: UIButtonX!
    @IBOutlet weak var btnOther: UIButtonX!
    @IBOutlet weak var btnChair: UIButtonX!
    @IBOutlet weak var btnSofa: UIButtonX!
    @IBOutlet weak var btnBed: UIButtonX!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var swtAudio: UISwitch!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var isRecord: UIButton!
    @IBOutlet weak var isPlay: UIButton!
    
    @IBOutlet weak var lbSearchPlane: UILabel!
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
    
    var x: Float!
    var z: Float!
    
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
        
        btnWardrobe.tag=0
        btnTable.tag=1
        btnPicture.tag=2
        btnLamp.tag=3
        btnOther.tag=4
        btnChair.tag=5
        btnSofa.tag=6
        btnBed.tag=7
        
        recorder = try! SceneKitVideoRecorder(withARSCNView: sceneView)
        navigationItem.title = ""
        var listCat : Array<Category> = Array()
        
        listCat.append(Category(id: 0, name: "wardrobe"))
        listCat.append(Category(id: 1, name: "table"))
        listCat.append(Category(id: 2, name: "picture"))
        listCat.append(Category(id: 3, name: "lamp"))
        listCat.append(Category(id: 4, name: "others"))
        listCat.append(Category(id: 5, name: "chair"))
        listCat.append(Category(id: 6, name: "sofa"))
        listCat.append(Category(id: 7, name: "bed"))
        
        for objCat in listCat{
            RealmService.shared.update(objCat)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection=[.horizontal,.vertical]

        // Run the view's session
        sceneView.session.run(configuration)
        configuration.isLightEstimationEnabled = true
        sceneView.debugOptions=[ARSCNDebugOptions.showFeaturePoints]
        
        self.lbSearchPlane.text = "Searching plane... "
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
                self.btnOther.transform = .identity
                self.btnLamp.transform = .identity
                self.btnPicture.transform = .identity
                self.btnWardrobe.transform = .identity
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
        btnOther.transform = CGAffineTransform(translationX: -6, y: -5)
        btnLamp.transform = CGAffineTransform(translationX: 0, y: -6)
        btnPicture.transform = CGAffineTransform(translationX: 0, y: -6)
        btnWardrobe.transform = CGAffineTransform(translationX: 6, y: -5)
        btnBed.transform = CGAffineTransform(translationX: 6, y: -2)
        btnSofa.transform = CGAffineTransform(translationX: 6, y: 0)
    }
    
    // Close option
    func closeOption(){
        self.optionView.transform = CGAffineTransform(translationX: 0 , y: 400)
    }
    
    @IBAction func returned(segue: UIStoryboardSegue) {
        closeMenu()
        btnMenu.transform = .identity
    }
    
    //TODO: fix this code
    func putItem(itemPath: String, id: Int) {
        print("itemPath \(itemPath)")
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        
        var firstNodeHitTest = sceneView.hitTest(view.center, options: hitTestOptions).first?.node
        
        let hit = sceneView.hitTest(view.center, types: .existingPlaneUsingExtent)
        
        if hit.isEmpty || firstNodeHitTest == nil{
            return
        }
        
        while true {
            if firstNodeHitTest?.parent == sceneView.scene.rootNode {
                break
            }
            firstNodeHitTest = firstNodeHitTest?.parent!
        }
        
        let material = SCNMaterial()
        let image = UIImage(named: "transparent")
        material.diffuse.contents = image
        firstNodeHitTest?.childNode(withName: "planeNode", recursively: true)?.geometry?.materials = [material]
        
        let node = SCNNode()
        let realm = try! Realm()
        let name = realm.objects(Category.self).filter("id=\(id)").first?.name
        let assetsPath = "art.scnassets/\(name!)"
        
        if let planeAnchor = hit.first?.anchor as? ARPlaneAnchor{
            if planeAnchor.alignment == .vertical{

                if (name == "picture" || itemPath == "stickynote" || itemPath == "WallClock") {
                    node.eulerAngles = (firstNodeHitTest?.eulerAngles)!
                }else{
                    closeAllAnimation()

                    let alert = UIAlertController(title: "Warning", message: "Can not put this item on the vertical plane", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))

                    self.present(alert, animated: true)
                    return
                }
            }
            let worldTransform = hit.first?.worldTransform
            let scenePath = "\(assetsPath)/\(itemPath)/\(itemPath).scn"
            chooseItem(path: scenePath,worldTransform: worldTransform!, node)
        }
    }
    
    func chooseItem( path: String,  worldTransform: matrix_float4x4,_ node: SCNNode){
        
        let scene=SCNScene(named: path)
        let nodeArray = scene?.rootNode.childNodes
        for childNode in nodeArray! {
            node.addChildNode(childNode)
        }
        
        node.position = SCNVector3((worldTransform.columns.3.x), worldTransform.columns.3.y, (worldTransform.columns.3.z))

//        node.geometry = SCNBox(width: CGFloat(node.scale.z), height: CGFloat(node.scale.y), length: CGFloat(node.scale.z), chamferRadius: 0)

        node.physicsBody?.categoryBitMask = 2
        node.physicsBody?.collisionBitMask = 1
        node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: node, options: nil))
        
        
        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.addChildNode(node)
            if self.swtAudio.isOn{
                self.audioConfigure(action: "add")
            }
        }
        closeMenu()
        btnMenu.transform = .identity
    }
}
