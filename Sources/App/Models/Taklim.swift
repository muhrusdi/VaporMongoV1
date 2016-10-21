import Vapor
import Fluent
import Foundation

final class Taklim: Model {
    var id: Node?
    var materi: String
    var pemateri: String
    var note: String
    var date: String
    var time: String?
    var tempat: String
    var pamflet: String
    var maps: (latitude: String, longitude: String)
    var createdAt: String?
    var updatedAt: String?
    var userId: String?
    var nameUser: String
    var exists: Bool = false
    
    init(materi: String, pemateri: String, note: String, date: String, time: String, tempat: String, pamflet: String, maps: (latitude: String, longitude: String), createdAt: String, updatedAt: String, userId: String, nameUser: String) {
        self.materi = materi
        self.pemateri = pemateri
        self.note = note
        self.date = date
        self.time = time
        self.tempat = tempat
        self.pamflet = pamflet
        self.maps = maps
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
        self.nameUser = nameUser
        
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.materi = try node.extract("materi")
        self.pemateri = try node.extract("pemateri")
        self.note = try node.extract("note")
        self.date = try node.extract("date")
        self.time = try node.extract("time")
        self.tempat = try node.extract("tempat")
        self.pamflet = try node.extract("pamflet")
        let mapsNode = node["maps"]?.nodeObject
        self.maps = ((mapsNode?["latitude"]?.string)!, (mapsNode?["longitude"]?.string)!) 
        self.createdAt = try node.extract("createdAt")
        self.updatedAt = try node.extract("updatedAt")
        self.userId = try node.extract("userId")
        self.nameUser = try node.extract("nameUser")
    }
    
    func makeNode(context: Context) throws -> Node {

        return try Node(node: [
                "id": id,
                "materi": materi,
                "pemateri": pemateri,
                "note": note,
                "date": date,
                "time": time,
                "tempat": tempat,
                "pamflet": pamflet,
                "maps": Node(node: [
                        "latitude": maps.latitude,
                        "longitude": maps.longitude
                    ]),
                "createdAt": createdAt,
                "updatedAt": updatedAt,
                "userId": userId,
                "nameUser": nameUser
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("taklims") { taklims in
            taklims.id()
            taklims.string("materi")
            taklims.string("pemateri")
            taklims.string("note")
            taklims.string("date")
            taklims.string("time")
            taklims.string("tempat")
            taklims.string("pamflet")
            taklims.string("maps")
            taklims.string("createdAt", optional: true)
            taklims.string("updatedAt", optional: true)
            taklims.string("userId")
            taklims.string("nameUser")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("taklims")
    }

}

extension Taklim {
    static func humanReadablePostTime(time: Double) -> String {
        let newsDate = NSDate(timeIntervalSince1970: time)
        let delta = abs(Int(newsDate.timeIntervalSinceNow))
        
        if delta < 3 {
            return "just now"
        } else if delta < 60 {
            return "\(delta) seconds ago"
        } else if delta < 120 {
            return "1 minute ago"
        } else if delta < 3600 {
            return "\(delta / 60) minutes ago"
        } else if delta < 7200 {
            return "1 hour ago"
        } else if delta < 86400 {
            return "\(delta / 3600) hours ago"
        } else if delta < 172800 {
            return "1 day ago"
        }
        
        return "\((delta / 86400) + 1) days ago"
    }
}


