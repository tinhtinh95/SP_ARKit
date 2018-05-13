import UIKit
import RealmSwift

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var currentSelectedItem:Int!
    @IBOutlet weak var collectionView: UICollectionView!

    var listImages: Results<ImageSave>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        //Custom size for collection items
        let itemSize = UIScreen.main.bounds.width/3-3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        collectionView.collectionViewLayout = layout
        
        //Custom for backItem of this screen
        let backItem = UIBarButtonItem()
        backItem.title = "Gallery"
        backItem.tintColor = UIColor.white
        
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.navigationBar.tintColor = UIColor.black
         navigationItem.title = "Gallery"
        
        listImages=RealmService.shared.realm.objects(ImageSave.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryImageCell
        
        cell.imageView.image = UIImage(data: listImages[indexPath.row].image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedItem = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailGalleryViewController {
            destination.imageName = listImages[currentSelectedItem].image
        }
    }
    
}
