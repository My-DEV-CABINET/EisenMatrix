//
//  TaskProtocol.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/21/24.
//

import SwiftData
import SwiftUI

protocol TaskModelStateProtocol {
    var allTasks: [Task] { get }
    var currentDayTasks: [Task] { get }
    var currentWeekTasks: [Task] { get }
    var currentMonthTasks: [Task] { get }
}

protocol TaskModelActionProtocol {
    func fetchCurrentWeekTask(currentWeek: Binding<[Date.WeekDay]>, context: ModelContext?)
    func fetchCurrentMonthTask(currentMonth: Binding<[Date.WeekDay]>, context: ModelContext?)
    func fetchAllTask(context: ModelContext?)
    func syncTask(currentDate: Binding<Date>, context: ModelContext?)
    func addTask(currentDate: Binding<Date>, task: Task, context: ModelContext?)
    func deleteTask(currentDate: Binding<Date>, task: Task, context: ModelContext?)
}
