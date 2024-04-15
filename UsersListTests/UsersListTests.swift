//
//  UsersListTests.swift
//  UsersListTests
//
//  Created by Daniel Carracedo  on 13/4/24.
//

import XCTest
@testable import UsersList

@MainActor
final class UsersListTests: XCTestCase {
    var sut: UsersViewModel!

    override func setUp() {
        sut = UsersViewModel(repository: MockUsersRepository())
        UserDefaultsManager.clearAll()
    }

    func test_tabAction_all_success() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.

        let expectation = XCTestExpectation(description: "Async operation")
        let expectedState: ViewState = .success // Suponiendo que el estado esperado sea éxito

        sut.tabAction(.all)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.5)

        XCTAssertEqual(sut.viewState, expectedState, "View state should be success after calling tabBarAction with .all")
        XCTAssertFalse(sut.users.isEmpty, "sut.users should not be empty after calling tabBarAction with .all")
        XCTAssertFalse(sut.usersFromApi.isEmpty, "sut.usersFromApi should not be empty after calling tabBarAction with .all")
    }

    func test_Update_User_Data() throws {
        // Given
        let mockUser1 = UserModel(id: ID(name: "mock1", value: "123"), phone: "123456789", login: Login(sha256: "mock", password: "mock", md5: nil, uuid: nil, username: "mock", sha1: nil, salt: nil), picture: Picture(large: "large1", thumbnail: "thumbnail1", medium: "medium1"), email: "mock1@example.com", gender: .male, name: Name(title: "Mr", first: "John", last: "Doe"), fullName: "John Doe")
        let mockUser2 = UserModel(id: ID(name: "mock2", value: "456"), phone: "987654321", login: Login(sha256: "mock", password: "mock", md5: nil, uuid: nil, username: "mock", sha1: nil, salt: nil), picture: Picture(large: "large2", thumbnail: "thumbnail2", medium: "medium2"), email: "mock2@example.com", gender: .female, name: Name(title: "Ms", first: "Jane", last: "Doe"), fullName: "Jane Doe")
        var users: [UserModel] = [mockUser1, mockUser2]

        let mockOldData = mockUser1

        let mockNewData = UserModel(id: ID(name: "mock1", value: "123"), phone: "987654321", login: Login(sha256: "mock", password: "updatedPassword", md5: nil, uuid: nil, username: "mock", sha1: nil, salt: nil), picture: Picture(large: "updatedLarge", thumbnail: "updatedThumbnail", medium: "updatedMedium"), email: "updated@example.com", gender: .male, name: Name(title: "Mr", first: "John", last: "Doe"), fullName: "John Doe")

        sut.users = users

        // When
        sut.updateUserData(mockOldData, mockNewData)

        // Then
        // Verificar si el usuario se ha actualizado correctamente en la lista
        XCTAssertEqual(sut.users.count, 2, "El número de usuarios no debe cambiar después de la actualización")
        XCTAssertEqual(sut.users.firstIndex(where: { $0.email == mockOldData.email }), nil, "El usuario antiguo debe haber sido eliminado de la lista")
        XCTAssertEqual(sut.users.firstIndex(where: { $0.email == mockNewData.email }), 0, "El usuario actualizado debe estar en la posición 0 de la lista")
        XCTAssertEqual(sut.users[0].phone, mockNewData.phone, "El número de teléfono del usuario actualizado debe ser el mismo que el nuevo número de teléfono")
        XCTAssertEqual(sut.users[0].login.password, mockNewData.login.password, "La contraseña del usuario actualizado debe ser la misma que la nueva contraseña")
        XCTAssertEqual(sut.users[0].email, mockNewData.email, "El correo electrónico del usuario actualizado debe ser el mismo que el nuevo correo electrónico")
        XCTAssertEqual(sut.users[0].gender, mockNewData.gender, "El género del usuario actualizado debe ser el mismo que el nuevo género")
        XCTAssertEqual(sut.users[0].name, mockNewData.name, "El nombre del usuario actualizado debe ser el mismo que el nuevo nombre")
        XCTAssertEqual(sut.users[0].fullName, mockNewData.fullName, "El nombre completo del usuario actualizado debe ser el mismo que el nuevo nombre completo")

        // Verificar si los datos actualizados se han guardado correctamente en UserDefaults
        let savedUsers = UserDefaultsManager.load([UserModel].self, forKey: .users)
        XCTAssertEqual(savedUsers?.count, 2, "El número de usuarios cargados desde UserDefaults debe ser igual al número de usuarios en la lista")
        XCTAssertEqual(savedUsers?.firstIndex(where: { $0.id == mockNewData.id }), 0, "El usuario actualizado debe estar en la posición 0 de los usuarios cargados desde UserDefaults")
        XCTAssertEqual(savedUsers?[0].phone, mockNewData.phone, "El número de teléfono del usuario cargado desde UserDefaults debe ser el mismo que el nuevo número de teléfono")
        XCTAssertEqual(savedUsers?[0].login.password, mockNewData.login.password, "La contraseña del usuario cargado desde UserDefaults debe ser la misma que la nueva contraseña")
        XCTAssertEqual(savedUsers?[0].picture.large, mockNewData.picture.large, "La URL de la imagen grande del usuario cargado desde UserDefaults debe ser la misma que la nueva URL de imagen grande")
        XCTAssertEqual(savedUsers?[0].email, mockNewData.email, "El correo electrónico del usuario cargado desde UserDefaults debe ser el mismo que el nuevo correo electrónico")
        XCTAssertEqual(savedUsers?[0].gender, mockNewData.gender, "El género del usuario cargado desde UserDefaults debe ser el mismo que el nuevo género")
        XCTAssertEqual(savedUsers?[0].name, mockNewData.name, "El nombre del usuario cargado desde UserDefaults debe ser el mismo que el nuevo nombre")
        XCTAssertEqual(savedUsers?[0].fullName, mockNewData.fullName, "El nombre completo del usuario cargado desde UserDefaults debe ser el mismo que el nuevo nombre completo")
    }

    func test_fetch_users() async throws {
        // When
        await sut.getUsers()

        // Then
        XCTAssertEqual(sut.viewState, .success, "El estado de la vista debe ser 'success' después de obtener los usuarios")
        XCTAssertFalse(sut.users.isEmpty, "La lista de usuarios no debe estar vacía después de obtener los usuarios")
        XCTAssertEqual(sut.users.count, 1, "El número de usuarios obtenidos debe ser igual a 2")
        XCTAssertEqual(sut.users[0].email, "mock@example.com", "El número de usuarios obtenidos debe ser igual a 2")
      }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
