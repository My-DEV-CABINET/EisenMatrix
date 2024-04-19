//
//  Task.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import SwiftData
import SwiftUI

@Model
final class Task: Identifiable {
    var id: UUID
    var taskTitle: String
    var taskMemo: String?
    var taskType: String
    var startDate: Date
    var endDate: Date?
    var isCompleted: Bool

    init(id: UUID = .init(), taskTitle: String, taskMemo: String? = nil, taskType: String, startDate: Date = .init(), endDate: Date? = nil, isCompleted: Bool = false) {
        self.id = id
        self.taskTitle = taskTitle
        self.taskMemo = taskMemo
        self.taskType = taskType
        self.startDate = startDate
        self.endDate = endDate
        self.isCompleted = isCompleted
    }
}

extension Task {
    static var mockupDatas: [Task] = [
        Task(taskTitle: "SwiftUI 공부하기", taskMemo: "스위프트UI 너무 어려워 ㅜㅡ", taskType: Matrix.Decide.info, startDate: Date.updateHour(0), isCompleted: false),
        Task(taskTitle: "Objective-C 공부하기", taskMemo: "Objective-C 너무 어려워 ㅜㅡ", taskType: Matrix.Do.info, startDate: Date.updateHour(10), isCompleted: true),
        Task(taskTitle: "RxSwift 공부하기", taskMemo: "RxSwift 너무 어려워 ㅜㅡ", taskType: Matrix.Delegate.info, startDate: Date.updateHour(3), isCompleted: true),
        Task(taskTitle: "공모전 준비", taskMemo: "공모전 너무 힘들어 ㅜㅡ", taskType: Matrix.Decide.info, startDate: Date.updateHour(-3), isCompleted: false),
        Task(taskTitle: "이력서 마무리하기", taskMemo: "이력서 너무 힘들어 ㅜㅡ", taskType: Matrix.Delete.info, startDate: Date.updateHour(-10), isCompleted: false),
    ]
}
