//
//  MonthTaskChartView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/22/24.
//

import Charts
import SwiftData
import SwiftUI

struct MonthTaskChartView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject private var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @ObservedObject private var dateContainer: DateContainer<DateIntent, DateModel>

    init(taskContainer: TaskContainer<TaskIntent, TaskModel>, dateContainer: DateContainer<DateIntent, DateModel>) {
        self.taskContainer = taskContainer
        self.dateContainer = dateContainer
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Task Month Total Count")
                Text("Total: \(taskContainer.model.currentMonthTasks.count)")
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            .padding()

            Chart {
                ForEach(dateContainer.model.currentMonth, id: \.id) { day in
                    BarMark(x: .value("x", day.date, unit: .day), y: .value("y", taskContainer.model.currentMonthTasks.filter { $0.creationDate.format("YYYY-MM-dd") == day.date.format("YYYY-MM-dd") }.count), width: 8)
                        .foregroundStyle(Color.pink.gradient)
                        .cornerRadius(6)
                }
            }
            .padding()
            .chartXAxis {
                AxisMarks(format: .dateTime.day(.defaultDigits))
            }

            .chartYAxis {
                AxisMarks(position: .trailing)
            }
        }
        .chartYScale(domain: 0 ... 10)
        .frame(height: 300)
        .padding()
        .overlay {
            if taskContainer.model.currentMonthTasks.isEmpty {
                Text("No Task's Found")
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundStyle(.gray)
                    .frame(width: 250, alignment: .center)
                    .offset(y: -10)
            }
        }

        .onAppear {
            dateContainer.intent.fetchCurrentMonth()
            taskContainer.intent.fetchCurrentMonthTask(currentMonth: $dateContainer.model.currentMonth, context: context)
        }
    }
}
