//
//  TaskProtocol.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/21/24.
//

import SwiftData
import SwiftUI

protocol TaskModelStateProtocol {
    var tasks: [Task] { get }
}

protocol TaskModelActionProtocol {
    func syncTask(currentDate: Binding<Date>, context: ModelContext?)
    func addTask(currentDate: Binding<Date>, task: Task, context: ModelContext?)
    func deleteTask(currentDate: Binding<Date>, task: Task, context: ModelContext?)
}
