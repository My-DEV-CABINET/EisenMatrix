//
//  TaskModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import SwiftData
import SwiftUI

final class TaskState: ObservableObject, TaskModelStateProtocol {
    @Published var allTasks: [Task]
    @Published var currentDayTasks: [Task]
    @Published var currentWeekTasks: [Task]
    @Published var currentMonthTasks: [Task]
    @Published var action: Action = .add
    @Published var editTask: Task?
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

extension TaskState: TaskModelActionProtocol {
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
    
    func updateTask(currentDate: Binding<Date>, task: Task, newTask: Task, context: ModelContext?) {
        if testMode != true {
            do {
                task.taskTitle = newTask.taskTitle
                task.taskMemo = newTask.taskMemo
                task.taskType = newTask.taskType
                task.creationDate = newTask.creationDate
                task.alertDate = newTask.alertDate
                task.isCompleted = newTask.isCompleted
                task.isAlert = newTask.isAlert

                try context?.save()
                syncTask(currentDate: currentDate, context: context)
            } catch {
                print("#### Swift Data Update Delete: \(error.localizedDescription)")
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
    
    func deleteAllSwiftDatasInContainer(context: ModelContext?) {
        do {
            try context?.delete(model: Task.self)
            
            allTasks = []
            currentDayTasks = []
            currentWeekTasks = []
            currentMonthTasks = []
            editTask = nil
        } catch {
            print("#### Swift Data All Delete Error: \(error.localizedDescription)")
        }
    }
    
    func encodeTaskToJSON(tasks: [Task]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(tasks)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                FileManageService.shared.makeFileAndWrite(json: jsonString)
            }
        } catch {
            print("#### Error encoding setting: \(error)")
        }
    }
    
    func decodeJSONToTask(json: Data, context: ModelContext?) {
        let decoder = JSONDecoder()
        
        do {
            let decodeDatas = try decoder.decode([Task].self, from: json)
            print("#### Decode: \(decodeDatas)")
            
            for data in decodeDatas {
                context?.insert(data)
            }
            try context?.save()
            
        } catch {
            print("#### Error Decoding setting: \(error.localizedDescription)")
        }
    }
}
