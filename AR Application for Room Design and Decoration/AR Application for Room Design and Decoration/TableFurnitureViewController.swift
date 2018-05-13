
import UIKit

protocol DesignAndDecorationDelegate {
    func putItem(itemPath: String, id: Int)
}

var idItem: String = ""

class TableFurnitureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var delegate:DesignAndDecorationDelegate?
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var lblTabItem: UILabel!
    @IBOutlet weak var coll: UICollectionView!
    
    var Dem:Int = 0
    var SItem:Array<String> = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch ID {
        case 0:
            Dem = arrListWardrobe.count
            break
        case 1:
            Dem = arrListTable.count
            break
        case 2:
            Dem = arrListPicture.count
            break
        case 3:
            Dem = arrListLamp.count
            break
        case 4:
            Dem = arrListOther.count
            break
        case 5:
            Dem = arrListChair.count
            break
        case 6:
             Dem = arrListSofa.count
            break
        case 7:
            Dem = arrListBed.count
            break
        default:
            return -1
        }
        return Dem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FurnitureCell
        cell.backgroundColor = #colorLiteral(red: 0.9882, green: 0.9882, blue: 0.9882, alpha: 1) /* #fcfcfc */
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1) /* #afafaf */
        
        switch ID {
        case 0:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListWardrobe
            cell.imgItem.image = UIImage(named: arrImgWardrobe[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 1:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListTable
            cell.imgItem.image = UIImage(named: arrImgTable[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 2:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListPicture
            cell.imgItem.image = UIImage(named: arrImgPicture[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 3:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListLamp
            cell.imgItem.image = UIImage(named: arrImgLamp[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 4:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListOther
            cell.imgItem.image = UIImage(named: arrImgOther[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 5:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListChair
            cell.imgItem.image = UIImage(named: arrImgChair[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 6:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListSofa
            cell.imgItem.image = UIImage(named: arrImgSofa[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 7:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListBed
            cell.imgItem.image = UIImage(named: arrImgBed[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break

        default:
            return cell
        }
        return cell
    }
    
    // Return Design screen
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.delegate?.putItem(itemPath: self.SItem[indexPath.row], id: ID)
        }
    }
    
    //List types Wardrobe
    let arrListWardrobe:Array<String> = ["wardrobe1", "wardrobe2", "wardrobe3", "wardrobe4", "wardrobe5", "wardrobe6", "wardrobe7", "wardrobe8", "wardrobe9", "wardrobe10"]
    let arrImgWardrobe:Array<String> = ["wardrobe1.png", "wardrobe2.png", "wardrobe3.png", "wardrobe4.png", "wardrobe5.png", "wardrobe6.png", "wardrobe7.png", "wardrobe8.png", "wardrobe9.png", "wardrobe10.png"]
    
    //List types table
    let arrListTable:Array<String> = ["table1", "table2", "table3", "table4"]
    let arrImgTable:Array<String> = ["table1.png", "table2.png", "table3.png", "table4.png"]
    
    //List types picture
    let arrListPicture:Array<String> = ["picture1", "logo_BK", "logo_IT"]
    let arrImgPicture:Array<String> = ["picture1.png", "logo_BK.png", "logo_IT.png"]
    
    //List types Lamp
    let arrListLamp:Array<String> = ["lamp1", "lamp2", "lamp3"]
    let arrImgLamp:Array<String> = ["lamp1.png", "lamp2.png", "lamp3.png"]

    //List types Other
    let arrListOther:Array<String> = ["cup", "vase", "stickynote", "apple", "WallClock"]
    let arrImgOther:Array<String> = ["cup.png", "vase.png", "stickynote.png", "apple.png", "WallClock.png"]
    
    //List types chair
    let arrListChair:Array<String> = ["chair1", "chair2", "chair3"]
    let arrImgChair:Array<String> = ["chair1.png", "chair2.png", "chair3.png"]
    
    //List types sofa
    let arrListSofa:Array<String> = ["sofa1", "sofa2", "sofa3", "sofa4", "sofa5", "sofa6", "sofa7", "sofa8", "sofa9", "sofa10"]
    let arrImgSofa:Array<String> = ["sofa1.png", "sofa2.png", "sofa3.png", "sofa4.png", "sofa5.png", "sofa6.png", "sofa7.png", "sofa8.png", "sofa9.png", "sofa10.png"]
    
    //List types bed
    let arrListBed:Array<String> = ["bed1", "bed2", "bed3", "bed4", "bed5", "bed6", "bed7", "bed8", "bed9", "bed10"]
    let arrImgBed:Array<String> = ["bed1.png", "bed2.png", "bed3.png", "bed4.png", "bed5.png", "bed6.png", "bed7.png", "bed8.png", "bed9.png", "bed10.png"]

    
    //List title Item
    var arrListItem:Array<String> = ["WARDROBE", "TABLE", "PICTURE", "LAMP", "OTHER", "CHAIR","SOFA", "BED"]
    var arrListItems:Array<String> = ["arrListWardrobe", "arrListTable", "arrListPicture", "arrListLamp", "arrListOther", "arrListChair", "arrListSofa", "arrListBed"]
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        super.viewDidLoad()
        coll.dataSource = self
        coll.delegate = self
        btnClose.layer.borderWidth = 0.5
        btnClose.layer.borderColor = #colorLiteral(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1) /* #afafaf */
        btnClose.layer.cornerRadius = btnClose.frame.width/2
        btnClose.layer.backgroundColor = #colorLiteral(red: 0.6863, green: 0.6863, blue: 0.6863, alpha: 1) /* #afafaf */
        bigView.roundCorners(corners: [.topLeft, .topRight], radius: bigView.frame.width/20)
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
