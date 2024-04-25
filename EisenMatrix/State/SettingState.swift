//
//  SettingState.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/24/24.
//

import SwiftUI

final class SettingState: ObservableObject, SettingStateProtocol {
    @Published var settings: [Setting]
    @Published var fileURL: URL?
    @Published var openFile: Bool
    @Published var confirmAlert: Bool

    init(settings: [Setting] = Setting.items, fileURL: URL? = nil, openFile: Bool = false, confirmAlert: Bool = false) {
        self.settings = settings
        self.fileURL = fileURL
        self.openFile = openFile
        self.confirmAlert = confirmAlert
    }
}
