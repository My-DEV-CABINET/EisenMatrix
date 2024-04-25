//
//  TaskView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

struct TaskView: View {
    @Environment(\.scenePhase) private var phase
    @EnvironmentObject var taskContainer: TaskContainer<TaskIntent, TaskState>
    @EnvironmentObject var dateContainer: DateContainer<DateIntent, DateState>

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            TaskHeaderView()
            TaskProcessView()
            ScrollView(.vertical) {
                VStack {
                    TaskListView()
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        })
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                dateContainer.model.createNewTask.toggle()
                taskContainer.model.action = Action.add
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(.blue.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
            })
            .padding(15)
        })

        .sheet(isPresented: $dateContainer.model.createNewTask, content: {
            NewTaskView(action: $taskContainer.model.action.wrappedValue, task: $taskContainer.model.editTask.wrappedValue ?? Task.mockupDatas[0])
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.66)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.bar)
        })

        .onDisappear {
            print("#### HomeView Deinit")
        }

        .onChange(of: phase) { oldValue, newValue in
            UNUserNotificationCenter.current().setBadgeCount(0)
            NotificationService.count = 0
        }
    }
}
