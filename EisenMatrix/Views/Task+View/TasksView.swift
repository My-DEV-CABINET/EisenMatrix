//
//  TasksView.swift
//  ExTaskManager
//
//  Created by 준우의 MacBook 16 on 2/14/24.
//

import Combine
import SwiftData
import SwiftUI

struct TasksView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @EnvironmentObject private var dateContainer: DateContainer<DateIntent, DateModel>

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

                    .onAppear(perform: {
                        if task.isAlert.wrappedValue == true, task.creationDate.wrappedValue.format("YYYY-MM-dd hh:mm") == Date.now.format("YYYY-MM-dd hh:mm") {
                            NotificationService.shared.pushNotification(title: task.taskTitle.wrappedValue, body: task.taskMemo.wrappedValue ?? "n/a", seconds: 1, identifier: task.id.uuidString)
                            task.isAlert.wrappedValue?.toggle()
                        }

                    })

                    .onChange(of: task.isAlert.wrappedValue) { oldValue, newValue in
                        if task.isAlert.wrappedValue == true, task.creationDate.wrappedValue.format("YYYY-MM-dd hh:mm") == Date.now.format("YYYY-MM-dd hh:mm") {
                            NotificationService.shared.pushNotification(title: task.taskTitle.wrappedValue, body: task.taskMemo.wrappedValue ?? "n/a", seconds: 1, identifier: task.id.uuidString)
                            task.isAlert.wrappedValue?.toggle()
                        }
                    }

                    .onReceive(dateContainer.model.$now, perform: { v in
                        print("#### \(v)")
                        if task.isAlert.wrappedValue == true, task.creationDate.wrappedValue.format("YYYY-MM-dd hh:mm") == Date.now.format("YYYY-MM-dd hh:mm") {
                            NotificationService.shared.pushNotification(title: task.taskTitle.wrappedValue, body: task.taskMemo.wrappedValue ?? "n/a", seconds: 1, identifier: task.id.uuidString)
                            task.isAlert.wrappedValue?.toggle()
                        }
                    })
            }
            .onChange(of: $dateContainer.model.currentDate.wrappedValue) { _, _ in
                taskContainer.intent.syncTask(currentDate: $dateContainer.model.currentDate, context: context)
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

        .onAppear(perform: {
            taskContainer.intent.syncTask(currentDate: $dateContainer.model.currentDate, context: context)
        })

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
