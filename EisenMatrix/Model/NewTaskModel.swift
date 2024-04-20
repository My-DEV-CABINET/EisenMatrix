//
//  NewTaskModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/21/24.
//

import SwiftUI

final class NewTaskModel: ObservableObject, NewTaskModelStateProtocol {
    @Published var taskTitle: String
    @Published var taskMemo: String
    @Published var taskDate: Date
    @Published var taskColor: Color
    @Published var placeHolder: String

    init(taskTitle: String = "", taskMemo: String = "", taskDate: Date = .now, taskColor: Color = Matrix.Do.color, placeHolder: String = "Enter a Task Memo Here!") {
        self.taskTitle = taskTitle
        self.taskMemo = taskMemo
        self.taskDate = taskDate
        self.taskColor = taskColor
        self.placeHolder = placeHolder
    }
}
