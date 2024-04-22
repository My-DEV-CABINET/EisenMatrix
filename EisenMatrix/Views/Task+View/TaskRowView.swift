//
//  TaskRowView.swift
//  ExTaskManager
//
//  Created by 준우의 MacBook 16 on 2/13/24.
//

import SwiftUI

struct TaskRowView: View {
    @Environment(\.modelContext) private var context

    @ObservedObject private var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @ObservedObject private var dateContainer: DateContainer<DateIntent, DateModel>
    @ObservedObject private var taskRowContainer: TaskRowContainer<TaskRowModel>

    @Binding private var task: Task

    init(taskContainer: TaskContainer<TaskIntent, TaskModel>, dateContainer: DateContainer<DateIntent, DateModel>, task: Binding<Task>) {
        self.taskContainer = taskContainer
        self.dateContainer = dateContainer
        self._task = task
        let taskRowModel = TaskRowModel()
        self.taskRowContainer = TaskRowContainer(model: taskRowModel, modelChangePublisher: taskRowModel.objectWillChange)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(task.isCompleted ? .green : .red)
                .frame(width: 15, height: 15)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(.circle)
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }
            ZStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: $taskRowContainer.model.isRowSelected.wrappedValue ? 20 : 10, content: {
                    Text(task.taskTitle)
                        .lineLimit(.max)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    if task.taskMemo?.isEmpty != true {
                        Text(task.taskMemo ?? "")
                            .font(.subheadline)
                            .lineLimit(.max)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    }

                    Label(task.creationDate.format("MM.dd hh:mm a"), systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.black)

                })

                Image(systemName: task.isAlert ?? false ? "bell" : "bell.slash")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .vSpacing(.center)
                    .hSpacing(.trailing)
            }

            .padding(15)
            .hSpacing(.leading)
            .frame(minHeight: $taskRowContainer.model.isRowSelected.wrappedValue ? 200 : 100, maxHeight: $taskRowContainer.model.isRowSelected.wrappedValue ? .infinity : 100)
            .background(Matrix.allCases.first(where: { $0.info == task.taskType })?.color ?? .red, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
            .onTapGesture {
                $taskRowContainer.model.isRowSelected.wrappedValue.toggle()
            }

            .contextMenu {
                Button(role: .none) {
                    /// Alert Task
                    task.isAlert?.toggle()

                } label: {
                    Text(task.isAlert ?? false ? "Alert Off" : "Alert On")
                }

                Button(role: .destructive) {
                    /// Deleting Task
                    taskContainer.intent.deleteTask(currentDate: $dateContainer.model.currentDate, task: task, context: context)

                } label: {
                    Text("Delete Task")
                }
            }
            .offset(y: -8)
        }

        .onDisappear {
            print("#### TaskRowView Deinit")
        }
    }
}

