//
//  TasksView.swift
//  ExTaskManager
//
//  Created by 준우의 MacBook 16 on 2/14/24.
//

import Combine
import SwiftData
import SwiftUI
import WidgetKit

struct TaskListView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var taskContainer: TaskContainer<TaskIntent, TaskState>
    @EnvironmentObject private var dateContainer: DateContainer<DateIntent, DateState>

    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach($taskContainer.model.currentDayTasks, id: \.id) { task in
                TaskRowView(task: task)
                    .background(alignment: .leading) {
                        if $taskContainer.model.currentDayTasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 3)
                                .offset(x: 10)
                                .padding(.bottom, -35)
                        }
                    }

                    .onChange(of: task.isAlert.wrappedValue) { oldValue, newValue in
                        task.isAlert.wrappedValue?.toggle()

                        guard let isAlert = task.isAlert.wrappedValue else { return }
                        if isAlert {
                            NotificationService.shared.pushNotification(date: task.creationDate.wrappedValue, task: task.wrappedValue)
                        } else {
                            NotificationService.shared.removeNotification(task: task.wrappedValue)
                        }
                    }
            }
            .onChange(of: $dateContainer.model.currentDate.wrappedValue) { _, _ in
                taskContainer.intent.syncTask(currentDate: $dateContainer.model.currentDate, context: context)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
        .overlay {
            if $taskContainer.model.currentDayTasks.wrappedValue.isEmpty {
                Text("No Task's Found")
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundStyle(.gray)
                    .frame(width: 250, alignment: .center)
                    .position(y: UIScreen.main.bounds.height / 3.5)
            }
        }

        .task {
            taskContainer.intent.syncTask(currentDate: $dateContainer.model.currentDate, context: context)
            WidgetCenter.shared.reloadAllTimelines()
        }

        .onDisappear {
            print("#### TasksView Deinit")
        }
    }

    func Notify() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "Timer Is Completed Successfully In Background !!!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
}
