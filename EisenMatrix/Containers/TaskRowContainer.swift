//
//  TaskRowContainer.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/21/24.
//

import Combine
import SwiftUI

final class TaskRowContainer<Model>: ObservableObject {
    var model: Model

    var subscriptions = Set<AnyCancellable>()

    init(model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.model = model

        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &subscriptions)
    }
}
