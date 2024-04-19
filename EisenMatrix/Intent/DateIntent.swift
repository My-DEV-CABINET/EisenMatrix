//
//  DateIntent.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import SwiftUI

final class DateIntent {
    private var model: DateModelAcionsProtocol?

    init(model: DateModelAcionsProtocol) {
        self.model = model
    }

    func paginateWeek() {
        model?.paginateWeek()
    }
}

protocol DateModelAcionsProtocol: AnyObject {
    func paginateWeek()
}

protocol DateModelStateProtocol {
    var currentDate: Date { get }
    var weekSlider: [[Date.WeekDay]] { get }
    var currentWeekIndex: Int { get }
    var createWeek: Bool { get }
    var createNewTask: Bool { get }
}
