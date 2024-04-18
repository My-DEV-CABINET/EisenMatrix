//
//  TaskContainer.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import Foundation

final class TaskContainer<Intent, Model>: ObservableObject {
    @Published var model: Model

    init(model: Model) {
        self.model = model
    }

    func applyIntent(intent: TasksIntent) {
        switch intent {
        case .addTask(let task):
            if var tasksModel = model as? TasksModel {
                tasksModel.tasks.append(task)
                model = tasksModel as! Model
            }
        case .deleteTask(uuid: let uuid):
            if var taskModel = model as? TasksModel {
                taskModel.tasks.removeAll(where: { $0.id == uuid })
                model = taskModel as! Model
            }
        }
    }
}

enum Matrix {
    case Do
    case Decide
    case Delegate
    case Delete
}

struct TaskModel {
    var id: UUID = .init()
    var title: String
    var type: Matrix
    var startDate: String?
    var endDate: String?
    var isCompleted: Bool
}

extension TaskModel {
    static var mockupDatas: [TaskModel] = [
        TaskModel(title: "SwiftUI 공부하기", type: .Decide, isCompleted: false),
        TaskModel(title: "Objective-C 공부하기", type: .Do, isCompleted: true),
        TaskModel(title: "RxSwift 공부하기", type: .Delete, isCompleted: true),
        TaskModel(title: "공모전 준비", type: .Delete, isCompleted: false),
        TaskModel(title: "이력서 마무리하기", type: .Delegate, isCompleted: false),
    ]
}

struct TasksModel {
    var testMode: Bool
    var tasks: [TaskModel]

    init(testMode: Bool) {
        self.testMode = testMode
        if testMode == true {
            tasks = TaskModel.mockupDatas
        } else {
            tasks = []
        }
    }
}

enum TasksIntent {
    case addTask(task: TaskModel)
    case deleteTask(uuid: UUID)
}
