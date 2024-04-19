//
//  TasksIntent.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import SwiftData
import SwiftUI

final class TaskIntent {
    private var model: TaskModelActionProtocol?

    init(model: TaskModelActionProtocol) {
        self.model = model
    }

    func fetchTask(currentDate: Binding<Date>) {
        model?.fetchTask(currentDate: currentDate)
    }

    func addTask(task: Task, context: ModelContext?) {
        model?.addTask(task: task, context: context)
    }

    func deleteTask(task: Task, context: ModelContext?) {
        model?.deleteTask(task: task, context: context)
    }
}

protocol TaskModelStateProtocol {
    var tasks: [Task] { get }
}

protocol TaskModelActionProtocol {
    func fetchTask(currentDate: Binding<Date>)
    func addTask(task: Task, context: ModelContext?)
    func deleteTask(task: Task, context: ModelContext?)
}
