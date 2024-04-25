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
    @EnvironmentObject private var taskContainer: TaskContainer<TaskIntent, TaskState>
    @EnvironmentObject private var dateContainer: DateContainer<DateIntent, DateState>

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 4) {
                TotalTaskChartView(taskContainer: taskContainer, dateContainer: dateContainer)
                Spacer()
                WeekTaskChartView(taskContainer: taskContainer, dateContainer: dateContainer)
                Spacer()
                MonthTaskChartView(taskContainer: taskContainer, dateContainer: dateContainer)
            }
            .padding()
        }
    }
}

// #Preview {
//    ChartView()
// }
