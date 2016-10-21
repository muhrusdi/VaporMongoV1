import Vapor
import HTTP
import Foundation

final class UserController {
    let droplet: Droplet
    
    init() {
        droplet = Droplet()
    }
    
    func login(_ request: Request) throws -> ResponseRepresentable {
        guard let email = request.data["email"]?.string, let password = request.data["password"]?.string else {
            throw Abort.badRequest
        }
        
        let hash = try droplet.hash.make(password)
        
        guard let user = try User.query().filter("email", .equals, email).filter("hash", .equals, hash).first() else {
            return try Response(status: .unauthorized, json: JSON(node:["message": "Email/password salah"]))
        }
        
        return try Response(status: .ok, json: JSON(node: user))
    }
    
    func register(_ request: Request) throws -> ResponseRepresentable {
        
        guard let firstName = request.multipart?["firstName"]?.string,
            let lastName = request.multipart?["lastName"]?.string,
            let email = request.multipart?["email"]?.string,
            let password = request.multipart?["password"]?.string,
            let avatar = request.multipart?["image"]?.file else {
                throw Abort.badRequest
        }
        
        let hash = try drop.hash.make(password)
        
        var user = User(firstName: firstName, lastName: lastName, email: email, hash: hash, avatar: getImagePath(img: avatar))
        
        guard try User.query().filter("email", user.email).first() == nil else {
            return try Response(status: .conflict, json: JSON(node: ["message": "Email sudah ada"]))
        }
        
        user.createdAt = "\(Date())"
        user.updatedAt = "\(Date())"
        try user.save()
        return try Response(status: .ok, json: JSON(node: user))
    }
    
    func getUser(_ request: Request) throws -> ResponseRepresentable {
        guard let id = request.parameters["id"]?.string else {
            throw Abort.badRequest
        }
        
        guard let user = try User.query().filter("_id", id).first() else {
            throw Abort.notFound
        }
        
        return user
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
//>>>>>>> 1387b714e55a41608403452b3b37825657916ca9
    }
    
}


