//
//  UserDefaultManager.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import Foundation
import UIKit
// Esta lógica para persistencia de datos tambien podría realizarse con CoreData, pero he utilizado UserDefaults para reducir el tiempo de desarrollo (creación de tablas etc)
// Enumeración que define claves para almacenar datos en UserDefaults.
public enum UserDefaultsConstant: String {
    case users
}

/// `UserDefaultsManager` es una estructura de utilidad que facilita la manipulación de datos Codable en UserDefaults.
///
/// Puedes utilizar esta estructura para guardar y cargar objetos codificables en UserDefaults de manera sencilla.
///
/// Ejemplo de uso:
/// ```
/// // Guardar un objeto Codable
/// let customer = Customer(name: "John Doe")
/// UserDefaultsManager.save(customer, forKey: .customer)
///
/// // Cargar un objeto Codable
/// let customer: Customer? = UserDefaultsManager.load(Customer.self, forKey: .customer)
/// ```
public struct UserDefaultsManager {
    /// Guarda un objeto codificable en UserDefaults.
    ///
    /// - Parameters:
    ///   - value: Objeto que se va a guardar.
    ///   - key: Clave asociada a los datos en UserDefaults.
    public static func save<T: Encodable>(_ value: T, forKey key: UserDefaultsConstant) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(value) {
            UserDefaults.standard.set(encodedData, forKey: key.rawValue)
        }
    }

    /// Recupera un objeto decodificable de UserDefaults.
    ///
    /// - Parameters:
    ///   - type: Tipo del objeto que se va a recuperar.
    ///   - key: Clave asociada a los datos en UserDefaults.
    /// - Returns: Objeto recuperado o nulo si no se encontraron datos.
    public static func load<T: Decodable>(_ type: T.Type, forKey key: UserDefaultsConstant) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key.rawValue),
           let decodedObject = try? JSONDecoder().decode(type, from: savedData) {
            return decodedObject
        }
        return nil
    }

    /// Borra todos los datos cacheados en UserDefaults.
    public static func clearAll() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    /// Borra un valor específico cacheado en UserDefaults.
    ///
    /// - Parameter key: Clave del valor a borrar.
    public static func clearValue(forKey key: UserDefaultsConstant) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    /// Guarda un objeto codificable en UserDefaults durante la ejecución de la aplicación.
    ///
    /// - Parameters:
    ///   - value: Objeto que se va a guardar.
    ///   - key: Clave asociada a los datos en UserDefaults.
    public static func saveDuringRuntime<T: Encodable>(_ value: T, forKey key: UserDefaultsConstant) {
        save(value, forKey: key)
        // Borra el valor al final de la ejecución de la aplicación
        NotificationCenter.default.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { _ in
            clearValue(forKey: key)
        }
    }
}
