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
    @Query var items: [Task]

    var testMode: Bool

    init(testMode: Bool) {
        self.testMode = testMode
        if testMode == true {
            tasks = Task.mockupDatas.sorted(by: { $0.startDate < $1.startDate })
        } else {
            tasks = []
        }
    }
}

extension TaskModel: TaskModelActionProtocol {
    func fetchTask(currentDate: Binding<Date>) {
//        let calendar = Calendar.current
//        /// 시작 날짜
//        let startOfDate = calendar.startOfDay(for: currentDate.wrappedValue)
//        /// 종료 날짜
//        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!
//        /// Filtering: Task Data 가 시작날짜, 끝나는 날짜 사이에 있는 데이터 출력
//        let predicate = #Predicate<Task> {
//            return $0.startDate >= startOfDate && $0.endDate ?? $0.startDate < endOfDate
//        }
//
//        /// Sorting
//        let sortDescriptor = [
//            SortDescriptor(\Task.startDate, order: .forward)
//        ]
//        /// Swift Data 에 Query 적용
//        _items = Query(filter: predicate, sort: sortDescriptor, animation: .spring)
//
        ////        tasks = items
//        let filterTask = tasks.filter { $0.startDate >= startOfDate && $0.endDate ?? $0.startDate < endOfDate }
//        tasks = filterTask
//        objectWillChange.send()
    }

    func addTask(task: Task, context: ModelContext?) {
        tasks.append(task)
        objectWillChange.send()

//        do {
//            context?.insert(task)
//            try context?.save()
//            objectWillChange.send()
//        } catch {
//            print("#### Swift Data Save Error: \(error.localizedDescription)")
//        }
    }

    func deleteTask(task: Task, context: ModelContext?) {
        objectWillChange.send()
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
//        do {
//            context?.delete(task)
//            try context?.save()
//        } catch {
//            print("#### Swift Data Save Delete: \(error.localizedDescription)")
//        }
    }
}
