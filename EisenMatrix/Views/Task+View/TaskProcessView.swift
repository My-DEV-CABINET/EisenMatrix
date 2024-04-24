//
//  TaskProcessView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/24/24.
//

import Combine
import SwiftData
import SwiftUI

struct TaskProcessView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var taskContainer: TaskContainer<TaskIntent, TaskState>
    @EnvironmentObject private var dateContainer: DateContainer<DateIntent, DateState>

    var body: some View {
        HStack {
            Text("PROCESS:")
                .bold()
                .foregroundStyle(Color.blue)

            ProgressView(value: Double(taskContainer.model.currentDayTasks.filter { $0.isCompleted == true }.count) / Double(taskContainer.model.currentDayTasks.count))
                .foregroundStyle(Color(UIColor.systemBlue))
                .frame(height: 10.0)
                .scaleEffect(x: 1, y: 4, anchor: .trailing)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .progressViewStyle(.linear)
        }
        .padding([.leading, .trailing, .bottom], 10)
        .onAppear(perform: {
            print("#### \(taskContainer.model.currentDayTasks.filter { $0.isCompleted == true }.count)")
        })
        .onDisappear {
            print("#### TasksView Deinit")
        }
    }
}
