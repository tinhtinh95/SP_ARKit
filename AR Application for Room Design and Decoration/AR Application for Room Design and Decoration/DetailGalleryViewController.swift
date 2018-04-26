import UIKit


class DetailGalleryViewController: UIViewController {

    var imageName:Data?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(data: imageName!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func detailAction(_ sender: Any) {
        let alert = UIAlertController(title: "Detail", message: "Developing...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"Detail\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
 
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "Delete", message: "Developing...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"Delete\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
