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
    private let server: UsersServerProtocol
    private let local: UsersLocalProtocol

    init (
        server: UsersServerProtocol = UsersServer(),
        local: UsersLocalProtocol = UsersLocal()
    ) {
        self.server = server
        self.local = local
    }

}

extension UsersRepository: UsersRepositoryProtocol {
    func fetchUsers() async throws -> UsersResponse {
        do {
            let users =  try await server.fetchUsers()

            // 
            local.saveUsers(data: users)

            return users
        } catch {
            throw error
        }
    }

    
}
