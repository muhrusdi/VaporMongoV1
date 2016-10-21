import Vapor
import HTTP
import VaporMongo

let drop = Droplet()
try drop.addProvider(VaporMongo.Provider.self)
drop.preparations = [Taklim.self, User.self]

let taklimController = TaklimController()
let userController = UserController()

drop.get("api/v1/taklim", handler: taklimController.index)
drop.get("api/v1/taklim/user/:id", handler: taklimController.getTaklimByIdUser)
drop.post("api/v1/taklim/:id", handler: taklimController.create)
drop.delete("api/v1/taklim/:id/user/:idUser", handler: taklimController.deleteById)
drop.delete("api/v1/taklim/all/:id/", handler: taklimController.deleteAll)

drop.get("api/v1/user/:id", handler: userController.getUser)
drop.post("api/v1/user/login", handler: userController.login)
drop.post("api/v1/user/register", handler: userController.register)

drop.run()

// mongodb://<dbuser>:<dbpassword>@ds019746.mlab.com:19746/db30data
// mongodb://<dbuser>:<dbpassword>@ds047146.mlab.com:47146/db300data
// mongodb://<dbuser>:<dbpassword>@ds019746.mlab.com:19746/db3000data
