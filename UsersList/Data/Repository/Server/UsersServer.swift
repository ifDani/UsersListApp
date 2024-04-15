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
    private var network = Network().manager


    func fetchUsers() async throws -> UsersResponse {
        return try await network.request(.get, url: Endpoint.empty.url)
    }
}
