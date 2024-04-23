//
//  EisenMatrixApp.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/8/24.
//

import SwiftUI

@main
struct EisenMatrixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        let taskModel = TaskModel(testMode: false)
        let taskIntent = TaskIntent(model: taskModel)

        let dateModel = DateModel()
        let dateIntent = DateIntent(model: dateModel)

        let taskContainer = TaskContainer(intent: taskIntent, model: taskModel, modelChangePublisher: taskModel.objectWillChange)
        let dateContainer = DateContainer(intent: dateIntent, model: dateModel, modelChangePublisher: dateModel.objectWillChange)

        WindowGroup {
            ContentView()
                .environmentObject(taskContainer)
                .environmentObject(dateContainer)
        }
        .modelContainer(for: Task.self)
    }
}
