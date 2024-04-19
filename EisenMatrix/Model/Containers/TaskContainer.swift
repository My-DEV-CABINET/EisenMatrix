//
//  TaskContainer.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import Combine
import SwiftData
import SwiftUI

final class TaskContainer<Intent, Model>: ObservableObject {
    var intent: Intent
    var model: Model

    var subscriptions = Set<AnyCancellable>()

    init(intent: Intent, model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model

        // 3
        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &subscriptions)
    }
}
