//
//  EisenMatrixApp.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/8/24.
//

import SwiftUI

@main
struct EisenMatrixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Task.self)
    }
}
