//
//  TasksView.swift
//  ExTaskManager
//
//  Created by 준우의 MacBook 16 on 2/14/24.
//

import SwiftData
import SwiftUI

struct TasksView: View {
    @StateObject var taskContainer = TaskContainer<TasksIntent, TasksModel>(model: TasksModel(testMode: true))

    @Binding var currentDate: Date
    /// SwiftData Dynamic Query

    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach(Array(taskContainer.model.tasks.enumerated()), id: \.element.id) { index, task in
                TaskRowView(task: $taskContainer.model.tasks[index])
                    .background(alignment: .leading) {
                        if taskContainer.model.tasks.last?.id != task.id {
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

#Preview {
    ContentView()
}
