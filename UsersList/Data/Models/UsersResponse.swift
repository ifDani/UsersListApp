//
//  UsersResponse.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 13/4/24.
//

import Foundation

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
    let nat, cell, phone: String?
    let login: Login
    let dob, registered: Dob?
    let picture: Picture?
    let location: Location?
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
struct Dob: Codable {
    let date: String?
    let age: Int?
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

// MARK: - ID
struct ID: Codable {
    let name: String?
    let value: String?
}

// MARK: - Location
struct Location: Codable {
    let street: Street?
    let city, country: String?
    let postcode: Postcode?
    let timezone: Timezone?
    let coordinates: Coordinates?
    let state: String?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let longitude, latitude: String?
}

enum Postcode: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Postcode"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
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
struct Login: Codable {
    let sha256: String
    let password, md5, uuid: String?

    let username, sha1, salt: String?
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String?
}

// MARK: - Picture
struct Picture: Codable {
    let large, thumbnail, medium: String?
}
