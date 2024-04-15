//
//  TabUnderlineView.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import SwiftUI

struct TabUnderlineView: View {
    @Binding var currentTab: Int 
    @Namespace var namespace

    @State var tabBarOptions: [TabOptions] = [.all, .male, .female, .strong ]
    var click: (TabOptions) -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.gray.frame(height: 1)
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { value in
                    HStack(spacing: 20) {
                        ForEach(Array(zip(self.tabBarOptions.indices,
                                          self.tabBarOptions)),
                                id: \.0,
                                content: {
                            index, option in
                            TabBarItem(currentTab: self.$currentTab,
                                       namespace: namespace.self,
                                       tabBarItemName: option.rawValue,
                                       tab: index) {
                                withAnimation {
                                    value.scrollTo(index)
                                    click(option)
                                }
                            }
                                       .id(index)
                        })
                    }.padding(.horizontal)
                }
            }
        }
        .frame(height: 40)
        .edgesIgnoringSafeArea(.all)
    }
}

// Enum para representar los diferentes estilos de texto
enum TabOptions: String {
    case all = "All"
    case male = "Male"
    case female = "Female"
    case strong = "Strong Password"
}

struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var tabBarItemName: String
    var tab: Int
    var click: () -> Void = {}

    var body: some View {
        Button {
            self.currentTab = tab
            click()
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .setStyle(size: 14, color: .black, weight: .semibold)
                    .padding(.trailing)

                if currentTab == tab {
                    Color.black
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame).padding(.trailing)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
