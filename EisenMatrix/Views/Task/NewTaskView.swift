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
    @EnvironmentObject var dateContainer: DateContainer<DateIntent, DateModel>
 
    // MVI 패턴으로 정리 필요
    @State private var taskTitle: String = ""
    @State private var textEditorText: String = ""
    @State private var taskDate: Date = .now
    @State private var taskColor: Color = Matrix.Do.color
    @State private var placeholder: String = "Enter a Task Memo Here!"
    
    @State private var isSwitch: Bool = false
    
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
                
                TextField("Enter a Task Title", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
                    
                Spacer(minLength: 10)
                    
                Text("Task Memo")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $textEditorText)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(minHeight: 100, maxHeight: 200)
                        .padding(.top, 8)
                        .padding(.horizontal, 8)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 2)
                     
                    if textEditorText.isEmpty {
                        Text($placeholder.wrappedValue)
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
                
                    DatePicker("", selection: $taskDate)
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
                let task = Task(taskTitle: taskTitle, taskMemo: textEditorText, taskType: type ?? Matrix.Do.info, startDate: taskDate)
                taskContainer.intent.addTask(currentDate: $dateContainer.model.currentDate, task: task, context: context)
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
    
