//
//  EisenMatrixApp.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/8/24.
//

import SwiftUI

@main
struct EisenMatrixApp: App {
    // TaskContainer 인스턴스를 생성합니다.
    var taskContainer: TaskContainer<TaskIntent, TaskModel>
    var dateContainer: DateContainer<DateIntent, DateModel>

    init() {
        // TaskModel과 TaskIntent를 초기화합니다.
        let taskModel = TaskModel(testMode: false) // 예시로 testMode를 true로 설정
        let taskIntent = TaskIntent(model: taskModel)
        taskContainer = TaskContainer(intent: taskIntent, model: taskModel, modelChangePublisher: taskModel.objectWillChange)

        let dateModel = DateModel(currentDate: .init(), weekSlider: [], currentWeekIndex: 1, createWeek: false, createNewTask: false)
        let dateIntent = DateIntent(model: dateModel)
        dateContainer = DateContainer(intent: dateIntent, model: dateModel, modelChangePublisher: dateModel.objectWillChange)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskContainer)
                .environmentObject(dateContainer)
        }
        .modelContainer(for: Task.self)
    }
}
