//
//  TabView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var taskContainer: TaskContainer<TaskIntent, TaskState>
    @EnvironmentObject var dateContainer: DateContainer<DateIntent, DateState>

    var body: some View {
        TabView {
            TaskView()
                .tabItem {
                    Image(systemName: "checklist")
                }

            ChartView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                }

            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
        .font(.headline)
        .onDisappear {
            print("#### MainTabView Deinit")
        }
    }
}
