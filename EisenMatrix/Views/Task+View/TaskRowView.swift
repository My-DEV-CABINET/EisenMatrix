//
//  TaskRowView.swift
//  ExTaskManager
//
//  Created by 준우의 MacBook 16 on 2/13/24.
//

import SwiftUI
import WidgetKit

struct TaskRowView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase

    @EnvironmentObject private var taskContainer: TaskContainer<TaskIntent, TaskState>
    @EnvironmentObject private var dateContainer: DateContainer<DateIntent, DateState>
    @StateObject private var taskRowContainer: TaskRowContainer<TaskRowState> = {
        let taskRowModel = TaskRowState()
        let taskRowContainer = TaskRowContainer(model: taskRowModel, modelChangePublisher: taskRowModel.objectWillChange)
        return taskRowContainer
    }()

    @Binding private var task: Task

    init(task: Binding<Task>) {
        self._task = task
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
                                WidgetCenter.shared.reloadAllTimelines()
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
                    .frame(width: 16, height: 16)
                    .scaledToFit()
                    .font(.footnote)
                    .foregroundStyle(Matrix.allCases.first(where: { $0.info == task.taskType })?.color ?? .red)
                    .padding(.all, 8)
                    .background(.white)
                    .clipShape(.circle)
                    .vSpacing(.center)
                    .hSpacing(.trailing)
            }

            .padding(15)
            .hSpacing(.leading)
            .frame(minHeight: $taskRowContainer.model.isRowSelected.wrappedValue ? 200 : 100, maxHeight: $taskRowContainer.model.isRowSelected.wrappedValue ? .infinity : 100)
            .background(Matrix.allCases.first(where: { $0.info == task.taskType })?.color ?? .red, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .opacity(task.isCompleted ? 0.5 : 1)
            .strikethrough(task.isCompleted, pattern: .solid, color: Color(UIColor.systemGray6))
            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
            .onTapGesture {
                $taskRowContainer.model.isRowSelected.wrappedValue.toggle()
            }

            .contextMenu {
                Button(role: .none) {
                    /// Edit Task
                    dateContainer.model.createNewTask.toggle()
                    taskContainer.model.action = Action.edit
                    taskContainer.model.editTask = task
                } label: {
                    Text("Edit Task")
                }

                Button(role: .none) {
                    /// Alert Task
                    task.isAlert?.toggle()

                } label: {
                    Text(task.isAlert ?? false ? "Alert Off" : "Alert On")
                }

                Divider()

                Button(role: .destructive) {
                    /// Deleting Task
                    taskContainer.intent.deleteTask(currentDate: $dateContainer.model.currentDate, task: task, context: context)
                    WidgetCenter.shared.reloadAllTimelines()

                } label: {
                    Text("Delete Task")
                }
            }
            .offset(y: -8)
        }

        .onChange(of: phase) { oldValue, newValue in
            task.isCompleted = task.isCompleted
            WidgetCenter.shared.reloadAllTimelines()
        }

        .onDisappear {
            print("#### TaskRowView Deinit")
        }
    }
}
