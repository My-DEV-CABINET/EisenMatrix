//
//  TaskRowModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/21/24.
//

import SwiftUI

final class TaskRowState: ObservableObject, TaskRowStateProtocol {
    @Published var isRowSelected: Bool

    init(isRowSelected: Bool = false) {
        self.isRowSelected = isRowSelected
    }
}
