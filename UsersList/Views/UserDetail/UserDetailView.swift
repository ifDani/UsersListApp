//
//  UserDetailView.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import SwiftUI

struct UserDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var user: UserModel
    var save: (UserModel) -> Void

    var body: some View {
        VStack {
            ProfileDataComponent


            TextFieldsComponent

            Spacer()

            ButtonSaveComponent
        }
        .padding(.horizontal)
    }
}

// MARK: - Local Components
extension UserDetailView {
    private var ProfileDataComponent: some View {
        Group {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: user.picture.large ?? ""))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.blue)
                    .font(.system(size: 25))
                    .offset(x: 6, y: 6)
            }

            Text(user.fullName)
                .setStyle(size: 14, color: .black, weight: .bold)

            HStack {
                Image(systemName: "phone.fill")
                    .foregroundStyle(.gray)
                Text(user.phone).setStyle(size: 13, color: .gray, weight: .regular)
            }
        }
    }

    private var TextFieldsComponent: some View {
        VStack(alignment: .leading) {
            Text("Email address")
                .setStyle(size: 14, color: .black, weight: .bold)

            TextField(user.email, text: $user.email)
                .textFieldStyle(.roundedBorder)


            Text("Password")
                .setStyle(size: 14, color: .black, weight: .bold)
            SecureField(user.login.password, text: $user.login.password)
                .textFieldStyle(.roundedBorder)
                .background(Color.gray.opacity(0.2))

            Text("Phone")
                .setStyle(size: 14, color: .black, weight: .bold)

            TextField(user.phone, text: .constant(""))
                .textFieldStyle(.roundedBorder)
                .disabled(true)
                .overlay {
                    Color.white.opacity(0.1)
                }
        }
        .padding(.top)
        
    }
    private var ButtonSaveComponent: some View {
        Button {
            save(user)
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Save")
                .setStyle(size: 14, color: .white, weight: .semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

}
