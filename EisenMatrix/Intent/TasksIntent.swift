//
//  TasksIntent.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import Foundation

enum TasksIntent {
    case addTask(task: TaskModel)
    case deleteTask(uuid: UUID)
}
