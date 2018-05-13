//
//  ItemViewController.swift
//  AR Application for Room Design and Decoration
//
//  Created by Darick on 4/12/18.
//  Copyright © 2018 Quan (Quinto) H. DINH. All rights reserved.
//

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
            Dem = arrListSofa.count
            break
        case 1:
            Dem = arrListBed.count
            break
        case 2:
            Dem = arrListWardrobe.count
            break
        case 4:
            Dem = arrListTableLamp.count
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
            SItem = arrListSofa
            cell.imgItem.image = UIImage(named: arrImgSofa[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 1:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListBed
            cell.imgItem.image = UIImage(named: arrImgBed[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 2:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListWardrobe
            cell.imgItem.image = UIImage(named: arrImgWardrobe[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 3:
            lblTabItem.text = arrListItem[ID]
            break
        case 4:
            lblTabItem.text = arrListItem[ID]
            SItem = arrListTableLamp
            cell.imgItem.image = UIImage(named: arrImgTableLamp[indexPath.row])
            cell.lblItem.text = SItem[indexPath.row]
            break
        case 5:
            lblTabItem.text = arrListItem[ID]
            break
        case 6:
            lblTabItem.text = arrListItem[ID]
            break
        case 7:
            lblTabItem.text = arrListItem[ID]
            break
        default:
            return cell
        }
        return cell
    }
    
    // Return Design screen
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.putItem(itemPath: SItem[indexPath.row], id: ID)
        dismiss(animated: true, completion: nil)
    }
    
    //List types sofa
    let arrListSofa:Array<String> = ["sofa1", "sofa2", "sofa3", "sofa4", "sofa5", "sofa6", "sofa7", "sofa8", "sofa9", "sofa10"]
    let arrImgSofa:Array<String> = ["sofa1.png", "sofa2.png", "sofa3.png", "sofa4.png", "sofa5.png", "sofa6.png", "sofa7.png", "sofa8.png", "sofa9.png", "sofa10.png"]
    
    //List types bed
    let arrListBed:Array<String> = ["bed1", "bed2", "bed3", "bed4", "bed5", "bed6", "bed7", "bed8", "bed9", "bed10"]
    let arrImgBed:Array<String> = ["bed1.png", "bed2.png", "bed3.png", "bed4.png", "bed5.png", "bed6.png", "bed7.png", "bed8.png", "bed9.png", "bed10.png"]
    
    //List types Wardrobe
    let arrListWardrobe:Array<String> = ["wardrobe1", "wardrobe2", "wardrobe3", "wardrobe4", "wardrobe5", "wardrobe6", "wardrobe7", "wardrobe8", "wardrobe9", "wardrobe10"]
    let arrImgWardrobe:Array<String> = ["wardrobe1.png", "wardrobe2.png", "wardrobe3.png", "wardrobe4.png", "wardrobe5.png", "wardrobe6.png", "wardrobe7.png", "wardrobe8.png", "wardrobe9.png", "wardrobe10.png"]
    
    //List types Lamp
    let arrListTableLamp:Array<String> = ["tableLamp1", "tableLamp2", "tableLamp3", "tableLamp4", "tableLamp5", "tableLamp6", "tableLamp7", "tableLamp8", "tableLamp9", "tableLamp10"]
    let arrImgTableLamp:Array<String> = ["tableLamp1.png", "tableLamp2.png", "tableLamp3.png", "tableLamp4.png", "tableLamp5.png", "tableLamp6.png", "tableLamp7.png", "tableLamp8.png", "tableLamp9.png", "tableLamp10.png"]
    
    //List title Item
    var arrListItem:Array<String> = ["SOFA", "BED", "WARDROBE", "DESK", "LAMP", "SHELF", "CHAIR", "TABLE"]
    
    var arrListItems:Array<String> = ["arrListSofa", "arrListBed", "arrListWardrobe"]
    
    
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
