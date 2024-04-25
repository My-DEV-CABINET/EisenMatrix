//
//  NewTaskProtocol.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/21/24.
//

import SwiftUI

protocol NewTaskModelStateProtocol {
    var taskTitle: String { get }
    var taskMemo: String { get }
    var taskDate: Date { get }
    var taskColor: Color { get }
    var placeHolder: String { get }
    var isSwitch: Bool { get }
    var action: Action { get }
}
