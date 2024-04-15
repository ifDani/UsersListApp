//
//  Repository.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import Foundation
import NetworkSpm
import Combine

protocol UsersRepositoryProtocol {
    func fetchUsers() async throws -> UsersResponse
}

final class UsersRepository {
    private let server: UsersServer

    init (server: UsersServer = UsersServer()) {
        self.server = server
    }

}

extension UsersRepository: UsersRepositoryProtocol {
    func fetchUsers() async throws -> UsersResponse {
        try await server.fetchUsers()
    }

    
}
