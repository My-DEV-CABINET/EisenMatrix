//
//  TaskModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import SwiftData
import SwiftUI

final class TaskModel: ObservableObject, TaskModelStateProtocol {
    @Published var tasks: [Task]
    @Query private var items: [Task]

    var testMode: Bool

    init(testMode: Bool) {
        self.testMode = testMode
        if testMode == true {
            tasks = Task.mockupDatas.sorted(by: { $0.creationDate < $1.creationDate })
        } else {
            tasks = []
        }
    }
}

extension TaskModel: TaskModelActionProtocol {
    func fetchAllTask(context: ModelContext?) {
        /// Sorting
        let sortDescriptor = [
            SortDescriptor(\Task.creationDate, order: .forward)
        ]

        let descriptor = FetchDescriptor<Task>(sortBy: sortDescriptor)

        do {
            let temp = try? context?.fetch(descriptor)
            tasks = temp ?? []

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
                tasks = temp ?? []

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
