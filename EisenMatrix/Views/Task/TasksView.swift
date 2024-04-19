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
    @EnvironmentObject var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @EnvironmentObject var dateContainer: DateContainer<DateIntent, DateModel>

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 35) {
                ForEach($taskContainer.model.tasks, id: \.id) { task in
                    TaskRowView(task: task)
                        .background(alignment: .leading) {
                            if $taskContainer.model.tasks.last?.id != task.id {
                                Rectangle()
                                    .frame(width: 1)
                                    .offset(x: 8)
                                    .padding(.bottom, -35)
                            }
                        }
                }
                .onChange(of: $dateContainer.model.currentDate.wrappedValue) { _, _ in
                    taskContainer.intent.fetchTask(currentDate: $dateContainer.model.currentDate, context: context)
                }
            }
            .padding([.vertical, .leading], 15)
            .padding(.top, 15)
            .overlay {
                if taskContainer.model.tasks.isEmpty {
                    Text("No Task's Found")
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundStyle(.gray)
                        .frame(width: 250)
                        .position(x: geometry.size.width / 2, y: UIScreen.main.bounds.height / 4)
                }
            }
            .onAppear(perform: {
                taskContainer.intent.fetchTask(currentDate: $dateContainer.model.currentDate, context: context)
            })
        }
    }
}

// #Preview {
//    ContentView()
// }
