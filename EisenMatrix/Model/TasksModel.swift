//
//  TasksModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import Foundation

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
