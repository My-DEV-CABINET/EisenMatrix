//
//  Matrix.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

enum Matrix: CaseIterable {
    case Do
    case Decide
    case Delegate
    case Delete

    var info: String {
        switch self {
        case .Do:
            return "Do"
        case .Decide:
            return "Decide"
        case .Delegate:
            return "Delegate"
        case .Delete:
            return "Delete"
        }
    }

    var color: Color {
        switch self {
        case .Do:
            return Color(UIColor.systemGreen)
        case .Decide:
            return Color(UIColor.systemBlue)
        case .Delegate:
            return Color(UIColor.systemOrange)
        case .Delete:
            return Color(UIColor.systemRed)
        }
    }
}
