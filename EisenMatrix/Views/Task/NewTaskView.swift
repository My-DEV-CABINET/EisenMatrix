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
    @EnvironmentObject var taskContainer: TaskContainer<TaskIntent, TaskModel>
 
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: Color = Matrix.Do.color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Go for a Walk!", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))

            })
            .padding(.top, 5)
        
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                })
                /// Giving Some Space for tapping
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
                                        .opacity(taskColor == matrix.color ? 1 : 0)
                                })
                                .hSpacing(.center)
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation {
                                        taskColor = matrix.color
                                    }
                                }
                        }
                    }
                })
            }
            .padding(.top, 5)
                    
            Spacer(minLength: 0)
                    
            Button(action: {
                let type = Matrix.allCases.filter { $0.color == taskColor }.first?.info
                let task = Task(taskTitle: taskTitle, taskType: type ?? Matrix.Do.info, startDate: taskDate)
                taskContainer.intent.addTask(task: task, context: context)
                dismiss()
            }, label: {
                Text("Create Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(Color(taskColor), in: .rect(cornerRadius: 10))
            })
            .disabled(taskTitle == "")
            .opacity(taskTitle == "" ? 0.5 : 1)
        })
        .padding(15)
    }
}

// #Preview {
//    NewTaskView()
//        .vSpacing(.bottom)
// }
    
