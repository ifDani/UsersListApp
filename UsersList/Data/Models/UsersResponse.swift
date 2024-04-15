//
//  UsersResponse.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 13/4/24.
//

import Foundation

// Comment: Habitualmente creo 2 modelos, uno para la response en la que vienen datos opcionales, y otro modelo, en el que todos los objetos dependientes deben no ser opcionales
// En este caso solo he agregado algunos no nullables para trabajar mejor, pero quedan otros opcionales para ahorrar tiempo
// MARK: - UsersResponse
struct UsersResponse: Codable {
    let results: [User]?
    let info: Info?
}

// MARK: - Info
struct Info: Codable {
    let version: String?
    let results: Int?
    let seed: String?
    let page: Int?
}

// MARK: - Result
struct User: Codable {
    let id: ID?
    let phone: String?
    var login: Login
    let picture: Picture?
    let email: String?
    let gender: Gender?
    let name: Name?

    var fullName: String? {
        guard let firstName = name?.first, let lastName = name?.last else {
            return nil
        }
        return "\(firstName) \(lastName)"
    }
}

// MARK: - Dob
struct Dob: Codable, Hashable {
    let date: String?
    let age: Int?
}

enum Gender: String, Codable, Hashable {
    case female = "female"
    case male = "male"
}

// MARK: - ID
struct ID: Codable, Hashable {
    let name: String?
    let value: String?
}

// MARK: - Street
struct Street: Codable {
    let number: Int?
    let name: String?
}

// MARK: - Timezone
struct Timezone: Codable {
    let description, offset: String?
}

// MARK: - Login
struct Login: Codable, Hashable {
    let sha256: String
    var password: String
    let md5, uuid: String?

    let username, sha1, salt: String?
}

// MARK: - Name
struct Name: Codable, Hashable {
    let title, first, last: String?
}

// MARK: - Picture
struct Picture: Codable, Hashable {
    let large, thumbnail, medium: String?
}


struct UserResponseModel: Codable {
    let results: [UserModel]
    let info: InfoModel

    init(from response: UsersResponse) {
        self.results = response.results?.map { UserModel(from: $0) } ?? []
        self.info = InfoModel(from: response.info ?? Info(version: nil, results: nil, seed: nil, page: nil))
    }
}

struct InfoModel: Codable {
    let version: String
    let results: Int
    let seed: String
    let page: Int

    init(from info: Info) {
        self.version = info.version ?? ""
        self.results = info.results ?? 0
        self.seed = info.seed ?? ""
        self.page = info.page ?? 0
    }
}

struct UserModel: Codable, Hashable {
    let id: ID
    let phone: String
    var login: Login
    let picture: Picture
    var email: String
    let gender: Gender
    let name: Name
    let fullName: String

    init(from user: User) {
        self.id = user.id ?? ID(name: "", value: "")
        self.phone = user.phone ?? ""
        self.login = user.login
        self.picture = user.picture ?? Picture(large: "", thumbnail: "", medium: "")
        self.email = user.email ?? ""
        self.gender = user.gender ?? .female
        self.name = user.name ?? Name(title: "", first: "", last: "")
        self.fullName = user.fullName ?? ""
    }
}
