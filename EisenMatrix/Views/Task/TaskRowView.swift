//
//  TaskRowView.swift
//  ExTaskManager
//
//  Created by 준우의 MacBook 16 on 2/13/24.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var task: TaskModel
    /// Model Context

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(.circle)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }

            VStack(alignment: .leading, spacing: 8, content: {
                Text(task.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)

                Label(task.startDate?.format("hh:mm a") ?? Date.now.format("hh:mm a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.black)
            })
            .padding(15)
            .hSpacing(.leading)
            .background(task.type.color, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
            .contextMenu {
                Button(role: .destructive) {
                    /// Deleting Task

                } label: {
                    Text("Delete Task")
                }
            }
            .offset(y: -8)
        }
    }

    var indicatorColor: Color {
        if task.isCompleted {
            return .blue
        }

        return .red
    }
}

#Preview {
    ContentView()
}