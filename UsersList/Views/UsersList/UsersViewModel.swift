//
//  UsersListViewModel.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import Foundation

final class UsersViewModel: ObservableObject {
    private let repository: UsersRepository
    @Published var users: [User] = []
    @Published var searchText: String = ""

    init(repository: UsersRepository = UsersRepository()) {
        self.repository = repository
    }

    func getUsers() async {
        do {
            let users = try await repository.fetchUsers().results

            await MainActor.run {
                self.users = users ?? []
            }
        } catch {
            print(error)
        }
    }

    func tabAction(_ option: TabOptions) {
        switch option {
        case .all:
            break
        case .male:
            break
        case .female:
            break
        case .strong:
            break
        }
    }

}
