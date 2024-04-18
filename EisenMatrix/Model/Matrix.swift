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

    var color: Color {
        switch self {
        case .Do:
            return .green
        case .Decide:
            return .yellow
        case .Delegate:
            return .orange
        case .Delete:
            return .red
        }
    }
}
