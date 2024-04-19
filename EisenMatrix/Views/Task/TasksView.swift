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
        }
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
        .overlay {
            if taskContainer.model.tasks.isEmpty {
                Text("No Task's Found")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(width: 150)
            }
        }
    }
}

// #Preview {
//    ContentView()
// }
