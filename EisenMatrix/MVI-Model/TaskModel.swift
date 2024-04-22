//
//  TaskModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import SwiftData
import SwiftUI

final class TaskModel: ObservableObject, TaskModelStateProtocol {
    @Published var allTasks: [Task]
    @Published var currentDayTasks: [Task]
    @Published var currentWeekTasks: [Task]
    @Published var currentMonthTasks: [Task]
    @Query private var items: [Task]

    private var testMode: Bool

    init(testMode: Bool) {
        self.testMode = testMode
        if testMode == true {
            // Mock Up Datas
            allTasks = Task.mockupDatas.sorted(by: { $0.creationDate < $1.creationDate })
            currentDayTasks = Task.mockupDatas.sorted(by: { $0.creationDate < $1.creationDate })
            currentWeekTasks = Task.mockupDatas.sorted(by: { $0.creationDate < $1.creationDate })
            currentMonthTasks = Task.mockupDatas.sorted(by: { $0.creationDate < $1.creationDate })
        } else {
            allTasks = []
            currentDayTasks = []
            currentWeekTasks = []
            currentMonthTasks = []
        }
    }
}

extension TaskModel: TaskModelActionProtocol {
    func fetchCurrentMonthTask(currentMonth: Binding<[Date.WeekDay]>, context: ModelContext?) {
        let calendar = Calendar.current

        let startOfDate = calendar.startOfDay(for: currentMonth.first!.date.wrappedValue)
        let endOfDate = calendar.startOfDay(for: currentMonth.last!.date.wrappedValue)

        /// Filtering: Task Data 가 시작날짜, 끝나는 날짜 사이에 있는 데이터 출력
        let predicate = #Predicate<Task> {
            return $0.creationDate >= startOfDate && $0.creationDate < endOfDate
        }

        /// Sorting
        let sortDescriptor = [
            SortDescriptor(\Task.creationDate, order: .forward)
        ]

        let descriptor = FetchDescriptor<Task>(predicate: predicate, sortBy: sortDescriptor)

        do {
            let temp = try? context?.fetch(descriptor)
            currentMonthTasks = temp ?? []

            objectWillChange.send()
        }
    }

    func fetchCurrentWeekTask(currentWeek: Binding<[Date.WeekDay]>, context: ModelContext?) {
        let calendar = Calendar.current

        let startOfDate = calendar.startOfDay(for: currentWeek.first!.date.wrappedValue)
        let endOfDate = calendar.startOfDay(for: currentWeek.last!.date.wrappedValue)
        /// Filtering: Task Data 가 시작날짜, 끝나는 날짜 사이에 있는 데이터 출력
        let predicate = #Predicate<Task> {
            return $0.creationDate >= startOfDate && $0.creationDate < endOfDate
        }

        /// Sorting
        let sortDescriptor = [
            SortDescriptor(\Task.creationDate, order: .forward)
        ]

        let descriptor = FetchDescriptor<Task>(predicate: predicate, sortBy: sortDescriptor)

        do {
            let temp = try? context?.fetch(descriptor)
            currentWeekTasks = temp ?? []

            objectWillChange.send()
        }
    }

    func fetchAllTask(context: ModelContext?) {
        /// Sorting
        let sortDescriptor = [
            SortDescriptor(\Task.creationDate, order: .forward)
        ]

        let descriptor = FetchDescriptor<Task>(sortBy: sortDescriptor)

        do {
            let temp = try? context?.fetch(descriptor)
            allTasks = temp ?? []

            objectWillChange.send()
        }
    }

    func syncTask(currentDate: Binding<Date>, context: ModelContext?) {
        if testMode != true {
            let calendar = Calendar.current

            let startOfDate = calendar.startOfDay(for: currentDate.wrappedValue)
            let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!

            /// Filtering: Task Data 가 시작날짜, 끝나는 날짜 사이에 있는 데이터 출력
            let predicate = #Predicate<Task> {
                return $0.creationDate >= startOfDate && $0.creationDate < endOfDate
            }

            /// Sorting
            let sortDescriptor = [
                SortDescriptor(\Task.creationDate, order: .forward)
            ]

            let descriptor = FetchDescriptor<Task>(predicate: predicate, sortBy: sortDescriptor)

            do {
                let temp = try? context?.fetch(descriptor)
                currentDayTasks = temp ?? []

                objectWillChange.send()
            }
        }
    }

    func addTask(currentDate: Binding<Date>, task: Task, context: ModelContext?) {
        if testMode != true {
            do {
                context?.insert(task)
                try context?.save()
                syncTask(currentDate: currentDate, context: context)
            } catch {
                print("#### Swift Data Save Error: \(error.localizedDescription)")
            }
        }
    }

    func deleteTask(currentDate: Binding<Date>, task: Task, context: ModelContext?) {
        if testMode != true {
            do {
                context?.delete(task)
                try context?.save()
                syncTask(currentDate: currentDate, context: context)
            } catch {
                print("#### Swift Data Save Delete: \(error.localizedDescription)")
            }
        }
    }
}
