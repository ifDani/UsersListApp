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
    func fetchUsers(gender: Gender?, isSecurePassword: Bool) async throws -> UsersResponse
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
    func fetchUsers(gender: Gender? = nil, isSecurePassword: Bool = false) async throws -> UsersResponse {
        do {
            let users =  try await server.fetchUsers(gender: gender, isSecurePassword: isSecurePassword)

            // 
            local.saveUsers(data: users)

            return users
        } catch {
            throw error
        }
    }

    
}
