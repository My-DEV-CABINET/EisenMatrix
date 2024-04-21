//
//  ChartView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import Charts
import SwiftData
import SwiftUI

struct ChartView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject private var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @ObservedObject private var dateContainer: DateContainer<DateIntent, DateModel>

    init(taskContainer: TaskContainer<TaskIntent, TaskModel>, dateContainer: DateContainer<DateIntent, DateModel>) {
        self.taskContainer = taskContainer
        self.dateContainer = dateContainer
    }

    var body: some View {
        VStack {
            Chart {
                ForEach(Matrix.allCases, id: \.self) { data in
                    SectorMark(angle: .value("name", $taskContainer.model.tasks.wrappedValue.filter { $0.taskType == data.info }.count), innerRadius: 80, outerRadius: data.info == "Do" ? 180 : 135, angularInset: 2)
                        .foregroundStyle(data.color)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            Text(data.info)
                                .bold()
                                .foregroundStyle(.white)
                        }
                }
            }
            .chartLegend(.visible)
            .frame(width: 300, height: 300)
            .padding()
            .onAppear {
                taskContainer.intent.fetchAllTask(context: context)
            }
        }
    }
}

//#Preview {
//    ChartView()
//}
