//
//  DateModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import Foundation

struct DateModel {
    var currentDate: Date
    var weekSlider: [[Date.WeekDay]]
    var currentWeekIndex: Int
    var createWeek: Bool
    var createNewTask: Bool
}
