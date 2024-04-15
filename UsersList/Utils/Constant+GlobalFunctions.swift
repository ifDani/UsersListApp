//
//  Constant+GlobalFunctions.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 13/4/24.
//

import Foundation


struct Constants {
    /// Here you can set the url of nonProd Api
    var urlServer: String {
    #if DEBUG
        return "https://randomuser.me/api/"
    #else
        return "https://randomuser.me/api/"
    #endif

    }
}
