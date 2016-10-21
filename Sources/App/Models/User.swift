import Vapor
import Fluent
import Foundation

final class User: Model {
    var id: Node?
    var firstName: String
    var lastName: String
    var email: String
    var hash: String
    var avatar: String
    var createdAt: String?
    var updatedAt: String?
    var exists: Bool = false
    
    init(firstName: String, lastName: String, email: String, hash: String, avatar: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.hash = hash
        self.avatar = avatar
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.firstName = try node.extract("firstName")
        self.lastName = try node.extract("lastName")
        self.email = try node.extract("email")
        self.hash = try node.extract("hash")
        self.avatar = try node.extract("avatar")
        self.createdAt = try node.extract("createdAt")
        self.updatedAt = try node.extract("updatedAt")

    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "hash": hash,
            "avatar": avatar,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("firstName")
            users.string("lastName")
            users.string("email")
            users.string("hash")
            users.string("avatar")
            users.string("createdAt")
            users.string("updatedAt")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
    
}
