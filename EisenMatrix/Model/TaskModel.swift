//
//  TaskModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import Foundation

struct TaskModel {
    var id: UUID = .init()
    var title: String
    var type: Matrix
    var startDate: Date?
    var endDate: Date?
    var isCompleted: Bool
}

extension TaskModel {
    static var mockupDatas: [TaskModel] = [
        TaskModel(title: "SwiftUI 공부하기", type: .Decide, isCompleted: false),
        TaskModel(title: "Objective-C 공부하기", type: .Do, isCompleted: true),
        TaskModel(title: "RxSwift 공부하기", type: .Delete, isCompleted: true),
        TaskModel(title: "공모전 준비", type: .Delete, isCompleted: false),
        TaskModel(title: "이력서 마무리하기", type: .Delegate, isCompleted: false),
    ]
}
