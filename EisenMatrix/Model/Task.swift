//
//  Task.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import SwiftData
import SwiftUI

@Model
final class Task: TaskProtocol {
    var id: UUID
    var taskTitle: String
    var taskMemo: String?
    var taskType: String
    var creationDate: Date
    var alertDate: Date?
    var isCompleted: Bool
    var isAlert: Bool?

    enum CodingKeys: String, CodingKey {
        case id, taskTitle, taskMemo, taskType, creationDate, alertDate, isCompleted, isAlert
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        taskTitle = try container.decode(String.self, forKey: .taskTitle)
        taskMemo = try container.decodeIfPresent(String.self, forKey: .taskMemo)
        taskType = try container.decode(String.self, forKey: .taskType)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        alertDate = try container.decodeIfPresent(Date.self, forKey: .alertDate)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        isAlert = try container.decodeIfPresent(Bool.self, forKey: .isAlert)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskTitle, forKey: .taskTitle)
        try container.encodeIfPresent(taskMemo, forKey: .taskMemo)
        try container.encode(taskType, forKey: .taskType)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encodeIfPresent(alertDate, forKey: .alertDate)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(isAlert, forKey: .isAlert)
    }

    init(id: UUID = .init(), taskTitle: String, taskMemo: String? = nil, taskType: String, creationDate: Date = .init(), alertDate: Date? = nil, isCompleted: Bool = false, isAlert: Bool? = false) {
        self.id = id
        self.taskTitle = taskTitle
        self.taskMemo = taskMemo
        self.taskType = taskType
        self.creationDate = creationDate
        self.alertDate = alertDate
        self.isCompleted = isCompleted
        self.isAlert = isAlert
    }
}

extension Task {
    static var mockupDatas: [Task] = [
        Task(taskTitle: "SwiftUI 공부하기", taskMemo: "스위프트UI 너무 어려워 ㅜㅡ", taskType: Matrix.Decide.info, creationDate: Date.updateHour(0), isCompleted: false, isAlert: true),
        Task(taskTitle: "Objective-C 공부하기", taskMemo: "Objective-C 너무 어려워 ㅜㅡ", taskType: Matrix.Do.info, creationDate: Date.updateHour(10), isCompleted: true, isAlert: false),
        Task(taskTitle: "RxSwift 공부하기", taskMemo: "RxSwift 너무 어려워 ㅜㅡ", taskType: Matrix.Delegate.info, creationDate: Date.updateHour(3), isCompleted: true, isAlert: true),
        Task(taskTitle: "공모전 준비", taskMemo: "공모전 너무 힘들어 ㅜㅡ", taskType: Matrix.Decide.info, creationDate: Date.updateHour(-3), isCompleted: false, isAlert: false),
        Task(taskTitle: "이력서 마무리하기", taskMemo: "이력서 너무 힘들어 ㅜㅡ", taskType: Matrix.Delete.info, creationDate: Date.updateHour(-10), isCompleted: false, isAlert: true),
    ]
}
