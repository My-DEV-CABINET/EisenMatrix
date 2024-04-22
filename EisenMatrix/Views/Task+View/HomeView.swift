//
//  TaskView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var taskContainer: TaskContainer<TaskIntent, TaskModel>
    @ObservedObject var dateContainer: DateContainer<DateIntent, DateModel>

    init(taskContainer: TaskContainer<TaskIntent, TaskModel>, dateContainer: DateContainer<DateIntent, DateModel>) {
        self.taskContainer = taskContainer
        self.dateContainer = dateContainer
        NotificationService.shared.setAuthorization()
    }

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

// struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
// }
