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
    func fetchUsers() async throws -> UsersResponse
}


final class UsersServer: UsersServerProtocol {


    func fetchUsers() async throws -> UsersResponse {

        let params: [String: Any] = [
            "results" : 20
        ]

        return try await NetworkController
            ._printChanges()
            .request(.get, url: Endpoint.empty.url, params: params, bodyType: .inQuery)
    }
}
