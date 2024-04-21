//
//  TaskView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @StateObject var dateContainer: DateContainer<DateIntent, DateModel>

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView(dateContainer: dateContainer)

            ScrollView(.vertical) {
                VStack {
                    TasksView(taskContainer: taskContainer, dateContainer: dateContainer)
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

        .sheet(isPresented: $dateContainer.model.createNewTask, content: {
            NewTaskView(taskContainer: taskContainer, dateContainer: dateContainer)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.66)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.bar)
        })
    }
}

extension HomeView {
    static func build() -> some View {
        let taskModel = TaskModel(testMode: false) // 예시로 testMode를 true로 설정
        let taskIntent = TaskIntent(model: taskModel)
        let taskContainer = TaskContainer(intent: taskIntent, model: taskModel, modelChangePublisher: taskModel.objectWillChange)

        let dateModel = DateModel(currentDate: .init(), weekSlider: [], currentWeekIndex: 1, createWeek: false, createNewTask: false)
        let dateIntent = DateIntent(model: dateModel)
        let dateContainer = DateContainer(intent: dateIntent, model: dateModel, modelChangePublisher: dateModel.objectWillChange)

        return HomeView(taskContainer: taskContainer, dateContainer: dateContainer)
    }
}

// struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
// }
