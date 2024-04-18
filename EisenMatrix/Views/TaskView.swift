//
//  TaskView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

struct TaskView: View {
    @StateObject var taskContainer = TaskContainer<TasksIntent, TasksModel>(model: TasksModel(testMode: true))

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(taskContainer.model.tasks, id: \.id) { task in
                        HStack {
                            Text(task.title)
                            Spacer()
                            if task.isCompleted {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            let task = taskContainer.model.tasks[index]
                            taskContainer.applyIntent(intent: .deleteTask(uuid: task.id))
                        }
                    })
                }

                Button(action: {
                    taskContainer.applyIntent(intent: .addTask(task: TaskModel(title: "Hello World", type: .Decide, isCompleted: true)))
                }, label: {
                    Text("ADD")
                })
            }
            .navigationTitle("할 일 목록")
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}
