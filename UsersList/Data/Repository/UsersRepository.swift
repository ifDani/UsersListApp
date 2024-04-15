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
    func fetchUsers(gender: Gender?, isSecurePassword: Bool) async throws -> UserResponseModel
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
    func fetchUsers(gender: Gender? = nil, isSecurePassword: Bool = false) async throws -> UserResponseModel {
        // Si hay datos en persistencia seran los que usaremos, estos se borraran al hacer pullToRefresh
        // Al devolver datos aleatorios la api, la persistencia no tiene mucho sentido, no obstante la he integrado como pone en las instrucciones
        if let users = local.getUsers() {
            return users
        } else {
            do {
                let users =  try await server.fetchUsers(gender: gender, isSecurePassword: isSecurePassword)

                let usersModel = UserResponseModel(from: users)

                local.saveUsers(data: usersModel)

                return usersModel
            } catch {
                throw error
            }
        }
    }

    
}
