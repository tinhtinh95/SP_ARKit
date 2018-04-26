import RealmSwift

class ImageDAO{
    
    func getObjects()->Results<GalleryImage>{
        return RealmService.shared.realm.objects(GalleryImage.self)
    }
    
    func add(object: GalleryImage){
        RealmService.shared.create(object)
    }
}
