//
//  View.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import SwiftUI

public extension View {
    /// Method that help you show a custom loading
    func showLoading(isLoading: Bool) -> some View {
        ZStack {
            self
                .disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)

            if isLoading {
                ProgressView()
            }
        }
        .animation(.default, value: isLoading)
    }
}
