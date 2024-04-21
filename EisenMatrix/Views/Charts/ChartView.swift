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
            VStack(spacing: 10) {
                Chart {
                    ForEach(Matrix.allCases, id: \.self) { data in
                        SectorMark(angle: .value("Tasks", $taskContainer.model.tasks.wrappedValue.filter { $0.taskType == data.info }.count), innerRadius: .ratio(0.5), outerRadius: 140, angularInset: 2)
                            .position(by: .value("Type", data.info))
                            .foregroundStyle(by: .value("Color", data.info))
                            .cornerRadius(6)
                            .annotation(position: .overlay, alignment: .center) {
                                if $taskContainer.model.tasks.wrappedValue.filter({ $0.taskType == data.info }).count != 0 {
                                    Text(data.info)
                                        .bold()
                                        .foregroundStyle(.black)
                                        .padding()
                                }
                            }
                    }
                }
                .chartLegend(position: .bottom, alignment: .center, spacing: 30)
                .frame(width: 250, height: 250)
                .padding()
                .overlay {
                    if taskContainer.model.tasks.isEmpty {
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Task Weekend Total Count")
                    
                    Text("Total: \(taskContainer.model.tasks.count)")
                        .fontWeight(.semibold)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                    
                    Chart {
                        ForEach(dateContainer.model.currentWeek, id: \.id) { day in
                            BarMark(x: .value("Date", day.date, unit: .day), y: .value("Value", taskContainer.model.tasks.filter { $0.creationDate.format("YYYY-MM-dd") == day.date.format("YYYY-MM-dd") }.count), width: 30)
                                .foregroundStyle(Color.pink.gradient)
                                .cornerRadius(6)
                        }
                    }
                    
                    .chartXAxis {
                        AxisMarks(preset: .aligned, position: .bottom, values: .stride(by: .day)) { date in
                            AxisValueLabel(format: .dateTime.weekday(), centered: true)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .trailing)
                    }
                    .chartYScale(domain: 0 ... 5)
                    .frame(height: 300)
                    .padding()
                    .overlay {
                        if taskContainer.model.tasks.isEmpty {
                            Text("No Task's Found")
                                .font(.system(size: 22, weight: .bold, design: .default))
                                .foregroundStyle(.gray)
                                .frame(width: 250, alignment: .center)
                                .offset(y: -10)
                        }
                    }
                    
                    .onAppear {
                        dateContainer.intent.fetchCurrentWeek()
                    }
                    
                    Spacer()
                    
                    Text("Task Month Total Count")
                    
                    Text("Total: \(taskContainer.model.tasks.count)")
                        .fontWeight(.semibold)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                    
                    Chart {
                        ForEach(dateContainer.model.currentMonth, id: \.id) { day in
                            BarMark(x: .value("x", day.date, unit: .day), y: .value("y", taskContainer.model.tasks.filter { $0.creationDate.format("YYYY-MM-dd") == day.date.format("YYYY-MM-dd") }.count), width: 8)
                                .foregroundStyle(Color.pink.gradient)
                                .cornerRadius(6)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(format: .dateTime.day(.defaultDigits))
                    }
                    
                    .chartYAxis {
                        AxisMarks(position: .trailing)
                    }
                    .chartYScale(domain: 0 ... 10)
                    .frame(height: 300)
                    .padding()
                    .overlay {
                        if taskContainer.model.tasks.isEmpty {
                            Text("No Task's Found")
                                .font(.system(size: 22, weight: .bold, design: .default))
                                .foregroundStyle(.gray)
                                .frame(width: 250, alignment: .center)
                                .offset(y: -10)
                        }
                    }
                    
                    .onAppear {
                        dateContainer.intent.fetchCurrentMonth()
                    }
                }
                .padding()
            }
        }
    }
}

// #Preview {
//    ChartView()
// }
