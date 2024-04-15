//
//  UsersServer.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import Foundation
import Combine
import NetworkSpm

protocol UsersServerProtocol {
    func fetchUsers(gender: Gender?, isSecurePassword: Bool) async throws -> UsersResponse
}


final class UsersServer: UsersServerProtocol {


    func fetchUsers(gender: Gender? = nil, isSecurePassword: Bool = false) async throws -> UsersResponse {

        var params: [String: Any] = [
            "results" : 20
        ]
        if let gender = gender {
            params["gender"] = gender.rawValue
        }

        if isSecurePassword {
            params["password"] = "special,upper,lower,number"
        }

        return try await NetworkController
            ._printChanges()
            .request(.get, url: Endpoint.empty.url, params: params, bodyType: .inQuery)
    }
}
