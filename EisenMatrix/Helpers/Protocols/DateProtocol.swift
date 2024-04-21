//
//  DateProtocol.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/21/24.
//

import Foundation

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
