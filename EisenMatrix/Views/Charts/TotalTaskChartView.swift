//
//  TotalTaskChartView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/22/24.
//

import Charts
import SwiftData
import SwiftUI

struct TotalTaskChartView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject private var taskContainer: TaskContainer<TaskIntent, TaskState>
    @ObservedObject private var dateContainer: DateContainer<DateIntent, DateState>

    init(taskContainer: TaskContainer<TaskIntent, TaskState>, dateContainer: DateContainer<DateIntent, DateState>) {
        self.taskContainer = taskContainer
        self.dateContainer = dateContainer
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Task Total Count")

                Text("Total: \(taskContainer.model.allTasks.count)")
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            .padding()

            Chart {
                ForEach(Matrix.allCases, id: \.self) { data in
                    SectorMark(angle: .value("Tasks", $taskContainer.model.allTasks.wrappedValue.filter { $0.taskType == data.info }.count), innerRadius: .ratio(0.618), outerRadius: 200, angularInset: 2)
                        .position(by: .value("Type", data.info))
                        .foregroundStyle(by: .value("Color", data.info))
                        .cornerRadius(6)
                        .annotation(position: .overlay, alignment: .center) {
                            if $taskContainer.model.allTasks.wrappedValue.filter({ $0.taskType == data.info }).count != 0 {
                                Text(data.info)
                                    .bold()
                                    .foregroundStyle(.black)
                                    .padding()
                            }
                        }
                }
            }
        }
        .chartLegend(position: .bottom, alignment: .center, spacing: 30)
        .frame(width: 400, height: 400)
        .padding()
        .overlay {
            if taskContainer.model.allTasks.isEmpty {
                Text("No Task's Found")
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundStyle(.gray)
                    .frame(width: 250, alignment: .center)
                    .offset(y: -10)
            }
        }

        .onAppear {
            taskContainer.intent.fetchAllTask(context: context)
        }
    }
}
