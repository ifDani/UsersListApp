//
//  MockUsersRepository.swift
//  UsersListTests
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import SwiftUI
@testable import UsersList
final class MockUsersRepository: UsersRepositoryProtocol {
    func fetchUsers(gender: Gender?, isSecurePassword: Bool) async throws -> UserResponseModel {
        let mockUser = User(id: ID(name: "mock", value: "123"), phone: "123456789", login: Login(sha256: "mock", password: "mock", md5: nil, uuid: nil, username: "mock", sha1: nil, salt: nil), picture: nil, email: "mock@example.com", gender: .male, name: Name(title: "Mr", first: "John", last: "Doe"))

        let mockInfo = Info(version: "1.0", results: 1, seed: "mock", page: 1)

        let mockResponse = UsersResponse(results: [mockUser], info: mockInfo)

        let userResponseModel = UserResponseModel(from: mockResponse)

        return userResponseModel
    }
}
