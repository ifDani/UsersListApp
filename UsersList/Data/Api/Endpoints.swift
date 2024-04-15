//
//  Endpoints.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 13/4/24.
//

import Foundation

enum Endpoint: String {

    case empty = ""

    var url: URL {
        return URL(string: "\(Constants().urlServer + self.rawValue)")!
    }


    func addParams(_ params: [String : Any]) -> URL {
        var urlComponents = URLComponents(string: self.url.absoluteString)!

        var queryItems: [URLQueryItem] = []
        for (key, value) in params {
            if let valueString = value as? String {
                let queryItem = URLQueryItem(name: key, value: valueString)
                queryItems.append(queryItem)
            }
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}
