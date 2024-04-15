//
//  Text.swift
//  UsersList
//
//  Created by Daniel Carracedo  on 15/4/24.
//

import Foundation
import SwiftUI


extension Text {
    func setStyle(size: CGFloat, color: Color, weight: Font.Weight) -> Text {
        self.font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}
