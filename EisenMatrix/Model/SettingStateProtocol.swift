//
//  SettingStateProtocol.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/24/24.
//

import Foundation

protocol SettingStateProtocol {
    var settings: [Setting] { get }
    var fileURL: URL? { get }
    var openFile: Bool { get }
    var confirmAlert: Bool { get }
}

import Combine
import SwiftData
import SwiftUI

final class SettingContainer<Model>: ObservableObject {
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
