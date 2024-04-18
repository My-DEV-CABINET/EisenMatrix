//
//  TaskView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var dateContainer = DateContainer<DateIntent, DateModel>(model: DateModel(currentDate: .init(), weekSlider: [], currentWeekIndex: 1, createWeek: false, createNewTask: false))

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView(dateContainer: dateContainer)

            ScrollView(.vertical) {
                VStack {
                    /// Tasks View
                    TasksView(currentDate: $dateContainer.model.currentDate)
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        })
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                dateContainer.model.createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(.blue.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
            })
            .padding(15)
        })
        .onAppear(perform: {
            if dateContainer.model.weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()

                if let firstDate = currentWeek.first?.date {
                    dateContainer.model.weekSlider.append(firstDate.createPreviousWeek())
                }

                dateContainer.model.weekSlider.append(currentWeek)

                if let lastDate = currentWeek.last?.date {
                    dateContainer.model.weekSlider.append(lastDate.createNextWeek())
                }
            }
        })
        .sheet(isPresented: $dateContainer.model.createNewTask, content: {
            NewTaskView()
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.orange)
        })
    }
}

// struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
// }
