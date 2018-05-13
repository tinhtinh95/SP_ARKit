import RealmSwift

class ImageSave: Object {

    @objc dynamic var image = Data()

    convenience init(_ image: Data){
        self.init()
        self.image = image
    }
}

