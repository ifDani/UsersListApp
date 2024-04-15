//
//  UsersView.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import SwiftUI

struct UsersView: View {
    @StateObject var viewModel = UsersViewModel()
    @State var tabSelected = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TabUnderlineView(currentTab: $tabSelected, tabBarOptions:  [.all, .male, .female, .strong]) { option in
                viewModel.tabAction(option)
            }

            LazyVStack {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink(value: user) {
                        UserCardComponent(user)
                    }
                }
            }
            .padding(.horizontal)
        }
        .showLoading(isLoading: viewModel.viewState == .loading)
        .refreshable {
            tabSelected = 0
            viewModel.removeCaches()
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Users")
        .task {
            switch viewModel.viewState {
            case .idle, .error:
                await viewModel.getUsers()
            case .loading, .success:
                break
            }
        }
        .navigationDestination(for: UserModel.self) { value in
            UserDetailView(user: value) { user in
                viewModel.updateUserData(value, user)
            }
        }
    }
}

// MARK: - Local Components
extension UsersView {
    private func UserCardComponent(_ user: UserModel) -> some View {
        HStack {
            AsyncImage(url: URL(string: user.picture.medium ?? ""))
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))


            VStack(alignment: .leading) {
                Text(user.fullName )
                    .setStyle(size: 14, color: .black, weight: .semibold)
                Text(user.email)
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
