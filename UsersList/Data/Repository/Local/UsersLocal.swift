//
//  UsersLocal.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import Foundation

protocol UsersLocalProtocol {
    func saveUsers(data: UserResponseModel)
    func getUsers() -> UserResponseModel?
}


final class UsersLocal: UsersLocalProtocol {
    let manager =  UserDefaultsManager.self

    func saveUsers(data: UserResponseModel) {
        manager.save(data, forKey: .users)
    }

    func getUsers() -> UserResponseModel? {
        manager.load(UserResponseModel.self, forKey: .users)
    }
}
