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

