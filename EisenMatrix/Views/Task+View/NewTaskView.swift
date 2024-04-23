//
//  NewTaskView.swift
//  ExTaskManager
//
//  Created by 준우의 MacBook 16 on 2/13/24.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @EnvironmentObject private var dateContainer: DateContainer<DateIntent, DateModel>
    @ObservedObject private var newTaskContainer: NewTaskContainer<NewTaskModel> // NewTaskView의 상태변화 관리(전담)
    
    init() {
        let newTaskModel = NewTaskModel()
        newTaskContainer = NewTaskContainer(model: newTaskModel, modelChangePublisher: newTaskModel.objectWillChange)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .tint(.red)
                })
                .hSpacing(.leading)
                
                Toggle(isOn: $newTaskContainer.model.isSwitch) {
                    Label("Alert", systemImage: newTaskContainer.model.isSwitch ? "bell.fill" : "bell.slash.fill")
                        .font(.subheadline)
                        .frame(width: 80, height: 30)
                        .foregroundStyle(.white)
                        .background(Color($newTaskContainer.model.taskColor.wrappedValue))
                        .clipShape(.rect(cornerRadius: 10))
                        .padding()
                }
                .toggleStyle(SwitchToggleStyle(tint: Color($newTaskContainer.model.taskColor.wrappedValue)))
                .padding(.trailing, 8)
            }
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Enter a Task Title", text: $newTaskContainer.model.taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
                    
                Spacer(minLength: 10)
                    
                Text("Task Memo")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $newTaskContainer.model.taskMemo)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(minHeight: 100, maxHeight: 200)
                        .padding(.top, 8)
                        .padding(.horizontal, 8)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 2)
                     
                    if $newTaskContainer.model.taskMemo.wrappedValue.isEmpty {
                        Text($newTaskContainer.model.placeHolder.wrappedValue)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.placeholder)
                            .lineSpacing(10)
                            .padding(.top, 16)
                            .padding(.horizontal, 12)
                    }
                }
                
            })
    
            .padding(.top, 5)
            .padding(.horizontal, 15)
        
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                
                    DatePicker("", selection: $newTaskContainer.model.taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                })
                
                .padding(.trailing, -15)
        
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 0) {
                        ForEach(Matrix.allCases, id: \.self) { matrix in
                            Circle()
                                .fill(matrix.color)
                                .frame(width: 20, height: 20)
                                .background(content: {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity($newTaskContainer.model.taskColor.wrappedValue == matrix.color ? 1 : 0)
                                })
                                .hSpacing(.center)
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation {
                                        $newTaskContainer.model.taskColor.wrappedValue = matrix.color
                                    }
                                }
                        }
                    }
                })
            }
            .padding(.top, 5)
                    
            Spacer(minLength: 0)
                    
            Button(action: {
                let type = Matrix.allCases.filter { $0.color == $newTaskContainer.model.taskColor.wrappedValue }.first?.info
                let task = Task(
                    taskTitle: $newTaskContainer.model.taskTitle.wrappedValue,
                    taskMemo: $newTaskContainer.model.taskMemo.wrappedValue,
                    taskType: type ?? Matrix.Do.info,
                    creationDate: $newTaskContainer.model.taskDate.wrappedValue,
                    isAlert: $newTaskContainer.model.isSwitch.wrappedValue
                )
                taskContainer.intent.addTask(currentDate: $dateContainer.model.currentDate, task: task, context: context)
                
                if newTaskContainer.model.isSwitch == true {
                    NotificationService.shared.pushNotification(date: newTaskContainer.model.taskDate, task: task)
                }
                
                dismiss()
            }, label: {
                Text("Create Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(Color($newTaskContainer.model.taskColor.wrappedValue), in: .rect(cornerRadius: 10))
            })
            .disabled($newTaskContainer.model.taskTitle.wrappedValue == "")
            .opacity($newTaskContainer.model.taskTitle.wrappedValue == "" ? 0.5 : 1)
        })
        .padding(15)
        .onDisappear {
            print("#### NewTaskView Deinit")
        }
    }
}

// #Preview {
//    NewTaskView()
//        .vSpacing(.bottom)
// }
    
