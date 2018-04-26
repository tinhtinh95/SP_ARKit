import RealmSwift

class GalleryVideo: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var path = ""
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ id: Int,_ name: String,_ path: String,_ date: Date){
        self.init()
        self.id = id
        self.name = name
        self.path = path
        self.date = date
    }
}
