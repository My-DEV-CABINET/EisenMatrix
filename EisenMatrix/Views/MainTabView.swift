//
//  TabView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @StateObject var dateContainer: DateContainer<DateIntent, DateModel>

    var body: some View {
        TabView {
            HomeView(taskContainer: taskContainer, dateContainer: dateContainer)
                .tabItem {
                    Image(systemName: "checklist")
                }

            ChartView(taskContainer: taskContainer, dateContainer: dateContainer)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                }

            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
        .font(.headline)
    }
}

extension MainTabView {
    static func build() -> some View {
        let taskModel = TaskModel(testMode: false)
        let taskIntent = TaskIntent(model: taskModel)
        let taskContainer = TaskContainer(intent: taskIntent, model: taskModel, modelChangePublisher: taskModel.objectWillChange)

        let dateModel = DateModel(currentDate: .init(), weekSlider: [], currentWeekIndex: 1, createWeek: false, createNewTask: false)
        let dateIntent = DateIntent(model: dateModel)
        let dateContainer = DateContainer(intent: dateIntent, model: dateModel, modelChangePublisher: dateModel.objectWillChange)

        return MainTabView(taskContainer: taskContainer, dateContainer: dateContainer)
    }
}
