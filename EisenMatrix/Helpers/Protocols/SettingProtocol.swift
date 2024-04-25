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
