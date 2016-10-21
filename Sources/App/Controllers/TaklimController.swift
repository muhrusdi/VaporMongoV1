import Vapor
import HTTP
import Foundation

final class TaklimController {
    
    let drop: Droplet
    init() {
        drop = Droplet()
    }
    
    func index(_ request: Request) throws -> ResponseRepresentable {
        let all = try Taklim.all()
        
        all.forEach({ (taklim) in
            taklim.time = Taklim.humanReadablePostTime(time: Double(taklim.time!)!)
        })
        
        return try all.makeNode().converted(to: JSON.self)
    }
    
    func create(_ request: Request) throws -> ResponseRepresentable {
        guard let id = request.parameters["id"]?.string else {
            throw Abort.badRequest
        }
        
        guard let materi = request.multipart?["materi"]?.string,
            let pemateri = request.multipart?["pemateri"]?.string,
            let note = request.multipart?["note"]?.string,
            let date = request.multipart?["date"]?.string,
            let tempat = request.multipart?["tempat"]?.string,
            let latitude = request.multipart?["latitude"]?.string,
            let longitude = request.multipart?["longitude"]?.string,
            let pamflet = request.multipart?["image"]?.file,
            let nameUser = request.multipart?["nameUser"]?.string else {
                print("request gagal")
                throw Abort.badRequest
        }
        
        
        let time = "\(Date().timeIntervalSince1970)"
        let genDate = "\(Date())"
        let pamfletPath = getImagePath(img: pamflet)
        var taklim = Taklim(materi: materi, pemateri: pemateri, note: note, date: date, time: time, tempat: tempat, pamflet: pamfletPath, maps: (latitude, longitude), createdAt: genDate, updatedAt: genDate, userId: id, nameUser: nameUser)
        try taklim.save()
        return taklim
    }
    
    func getTaklimByIdUser(_ request: Request) throws -> ResponseRepresentable {
        guard let id = request.parameters["id"]?.string else {
            throw Abort.badRequest
        }

        let taklims = try Taklim.query().filter("userId", id).all()
        taklims.forEach({ (taklim) in
            taklim.time = Taklim.humanReadablePostTime(time: Double(taklim.time!)!)
        })
        return try JSON(node: taklims)
    }
    
    func deleteById(_ request: Request) throws -> ResponseRepresentable {
        guard let id = request.parameters["id"]?.string, let idUser = request.parameters["idUser"]?.string else {
            throw Abort.badRequest
        }
        
        guard let taklim = try Taklim.query().filter("userId", idUser).filter("_id", .equals, id).first() else {
            return Response(status: .notFound)
        }
        
        try taklim.delete()
        
        return Response(status: .accepted, headers: ["Content-Type": "applicaion/json"])
    }
    
    func deleteAll(_ request: Request) throws -> ResponseRepresentable {
        guard let id = request.parameters["id"]?.string else {
            throw Abort.badRequest
        }
        
        guard let taklim = try Taklim.query().filter("userId", id).first() else {
            return Response(status: .notFound)
        }
        
        try taklim.delete()
        
        return Response(status: .accepted, headers: ["Content-Type": "applicaion/json"])
    }

    
    private func getImagePath(img: Multipart.File) -> String {
        let data = Data(bytes: img.data)
        let fileManager = FileManager.default
        var dir: String!
        if img.type! == "image/jpg" {
            dir = "Public/images/\(img.name!)" + ".jpg"
        } else if img.type! == "image/png" {
            dir = "Public/images/\(img.name!)" + ".png"
        } else if img.type! == "image/jpeg" {
            dir = "Public/images/\(img.name!)" + ".jpeg"
        }
        let dirPath = drop.workDir + dir
        fileManager.createFile(atPath: dirPath, contents: data, attributes: ["name": img.name!, "type": img.type!])
        if fileManager.fileExists(atPath: dirPath) {
            
        } else {
            fileManager.createFile(atPath: dirPath, contents: data, attributes: ["name": img.name!, "type": img.type!])
        }
        print(img.type, img.name)
        return dir
    }
}

extension Request {
    func getTaklim() throws -> Taklim {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Taklim(node: json)
    }
}




