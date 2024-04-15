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
    @Published var users: [UserModel] = []
    @Published var usersFromApi: [UserModel] = []

    @Published var searchText = ""
    @Published var tabSelected = 0
    @Published var viewState: ViewState = .idle

    var searchSubscriber: Set<AnyCancellable> = []

    init(repository: UsersRepository = UsersRepository()) {
        self.repository = repository
        suscribeToSearch()
    }
}

// MARK: - Actions
extension UsersViewModel {
    func tabAction(_ option: TabOptions) {
        Task {
            // Comment: Aunque no lo pide en la práctica, por coherencia con el funcionamiento, en este caso eliminaremos persistencia
            // Esta logica de hecho emite un pequeño parpadeo, ya que en un momento dado no hay usuarios ( Aunque no se aprecia debido al showloading )
            removeCaches()
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
}

// MARK: - Local
extension UsersViewModel {
    func updateUserData(_ oldData: UserModel,_ newData: UserModel) {
        guard let index = users.firstIndex(where: { $0.id == oldData.id }) else {
            return // El usuario no se encontró en la lista
        }
        users[index] = newData // Actualizar el usuario en la lista
        // Modificamos los datos persistidos
        UserDefaultsManager.save(users, forKey: .users)
    }

    func removeCaches() {
        UserDefaultsManager.clearAll()
        Task {
            await getUsers()
        }
    }

    func queryFilter() {
        users = usersFromApi.filter { user in
            return user.fullName.localizedCaseInsensitiveContains(searchText)
        }
    }

    func suscribeToSearch() {
        // Comment: Aunque podriamos hacer la busqueda mápida debido a que es un filtrado local, he optado por esta solucion utilizando combin
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
            }
            .store(in: &searchSubscriber)
    }
}

// MARK: - Network
extension UsersViewModel {
    func getUsers(gender: Gender? = nil, secure: Bool = false) async {
        do {
            viewState = .loading

            let users = try await repository.fetchUsers(gender: gender, isSecurePassword: secure).results

            await MainActor.run {
                self.users = users
                self.usersFromApi = users
                viewState = .success
            }
        } catch {
            viewState = .error
            print(error)
        }
    }
}
