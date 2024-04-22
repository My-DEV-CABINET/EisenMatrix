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
    
    func fetchCurrentMonthTask(currentMonth: Binding<[Date.WeekDay]>, context: ModelContext?) {
        model?.fetchCurrentMonthTask(currentMonth: currentMonth, context: context)
    }
    
    func fetchCurrentWeekTask(currentWeek: Binding<[Date.WeekDay]>, context: ModelContext?) {
        model?.fetchCurrentWeekTask(currentWeek: currentWeek, context: context)
    }

    func fetchAllTask(context: ModelContext?) {
        model?.fetchAllTask(context: context)
    }

    func syncTask(currentDate: Binding<Date>, context: ModelContext?) {
        model?.syncTask(currentDate: currentDate, context: context)
    }

    func addTask(currentDate: Binding<Date>, task: Task, context: ModelContext?) {
        model?.addTask(currentDate: currentDate, task: task, context: context)
    }

    func deleteTask(currentDate: Binding<Date>, task: Task, context: ModelContext?) {
        model?.deleteTask(currentDate: currentDate, task: task, context: context)
    }
}
