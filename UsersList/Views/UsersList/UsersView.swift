//
//  UsersView.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import SwiftUI

struct UsersView: View {
    @StateObject var viewModel = UsersViewModel()
    var body: some View {
        VStack {
            //Barra de busqueda

            ScrollView(.vertical, showsIndicators: false) {
                TabUnderlineView(tabBarOptions:  [.all, .male, .female, .strong ]) { option in
                    viewModel.tabAction(option)
                }

                LazyVStack {
                    ForEach(viewModel.users, id: \.login.sha256) { user in
                        UserCardComponent(user)
                    }
                }
                .padding(.horizontal)
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Users")
        .task {
            await viewModel.getUsers()
        }
    }
}

// MARK: - Local Components
extension UsersView {
    private func UserCardComponent(_ user: User) -> some View {
            HStack {
                AsyncImage(url: URL(string: user.picture?.medium ?? ""))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))


                VStack(alignment: .leading) {
                    Text(user.fullName ?? "")
                        .setStyle(size: 14, color: .black, weight: .semibold)
                    Text(user.email ?? "")
                        .setStyle(size: 12, color: .black.opacity(0.7), weight: .regular)
                }
            }

        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .vertical])
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


#Preview {
    UsersView()
}
