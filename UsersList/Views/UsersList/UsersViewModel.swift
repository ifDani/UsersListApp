//
//  UsersListViewModel.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import Foundation
import Combine

final class UsersViewModel: ObservableObject {
    private let repository: UsersRepository
    @Published var users: [User] = []
    @Published var usersFromApi: [User] = []

    @Published var searchText = ""
    @Published var tabSelected = 0
    var searchSubscriber: Set<AnyCancellable> = []

    init(repository: UsersRepository = UsersRepository()) {
        self.repository = repository
        suscribeToSearch()
    }

    func getUsers(gender: Gender? = nil, secure: Bool = false) async {
        do {
            let users = try await repository.fetchUsers(gender: gender, isSecurePassword: secure).results

            await MainActor.run {
                self.users = users ?? []
                self.usersFromApi = users ?? []
            }
        } catch {
            print(error)
        }
    }

    func tabAction(_ option: TabOptions) {
        Task {
            switch option {
            case .all:
                await getUsers()
            case .male:
                await getUsers(gender: .male)
            case .female:
                await getUsers(gender: .female)
            case .strong:
                await getUsers(secure: true)

            }
        }
    }

    func suscribeToSearch() {
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ value -> String? in
                if value.count <= 2 {
                    //Remove filter
                    self.users = self.usersFromApi
                    return nil
                }

                return value
            })
            .compactMap { $0 }
            .sink { _ in } receiveValue: { _ in
                self.queryFilter()
            }.store(in: &searchSubscriber)
    }

    func queryFilter() {
        users = usersFromApi.filter { user in
            if let fullName = user.fullName {
                return fullName.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
    }

    func removeCaches() {
        tabSelected = 0
        UserDefaultsManager.clearAll()
        Task {
            await getUsers()
        }
    }

}
