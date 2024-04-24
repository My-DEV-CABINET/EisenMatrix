//
//  Setting.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/24/24.
//

import UIKit

struct Setting {
    var id: UUID = .init()
    var symbolName: String
    var title: String
    var description: String
    var color: UIColor
    var isShow: Bool = false
}

extension Setting {
    static let items: [Setting] = [
        Setting(symbolName: "eraser.line.dashed", title: "Data Reset", description: "You Can Delete All Datas", color: .systemRed),
        Setting(symbolName: "pencil.and.list.clipboard", title: "Data Import", description: "You Can Convert\n a JSON file Into a Task.", color: .systemOrange),
        Setting(symbolName: "square.and.arrow.up", title: "Data Export", description: "You Can Convert\n a Task Data to JSON file", color: .systemGreen)
    ]
}
