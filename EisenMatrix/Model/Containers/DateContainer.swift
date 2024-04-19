//
//  DateContainer.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import Combine
import SwiftUI

final class DateContainer<Intent, Model>: ObservableObject {
    var intent: Intent
    var model: Model

    private var subscriptions = Set<AnyCancellable>()

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
