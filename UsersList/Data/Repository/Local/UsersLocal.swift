//
//  UsersLocal.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import Foundation

protocol UsersLocalProtocol {
    func saveUsers(data: UsersResponse)
    func getUsers() -> UsersResponse?
}


final class UsersLocal: UsersLocalProtocol {
    let manager =  UserDefaultsManager.self

    func saveUsers(data: UsersResponse) {
        manager.save(data, forKey: .users)
    }

    func getUsers() -> UsersResponse? {
        manager.load(UsersResponse.self, forKey: .users)
    }


}
