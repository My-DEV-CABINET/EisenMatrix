//
//  DateProtocol.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/21/24.
//

import Foundation

protocol DateModelAcionsProtocol: AnyObject {
    func paginateWeek()
    func fetchCurrentWeek()
    func fetchCurrentMonth()
}

protocol DateModelStateProtocol {
    var currentDate: Date { get }
    var currentWeek: [Date.WeekDay] { get }
    var currentMonth: [Date.WeekDay] { get }
    var weekSlider: [[Date.WeekDay]] { get }
    var currentWeekIndex: Int { get }
    var createWeek: Bool { get }
    var createNewTask: Bool { get }
}
