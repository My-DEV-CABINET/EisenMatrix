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
    
    private let sampleDatas = Task.mockupDatas
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 8) {
                TotalTaskChartView(taskContainer: taskContainer, dateContainer: dateContainer)
                    
                   
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
