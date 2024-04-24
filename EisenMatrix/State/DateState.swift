//
//  DateModel.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import Combine
import SwiftUI

final class DateState: ObservableObject, DateModelStateProtocol {
    @Published var currentDate: Date
    @Published var currentWeek: [Date.WeekDay]
    @Published var currentMonth: [Date.WeekDay]
    @Published var weekSlider: [[Date.WeekDay]]
    @Published var currentWeekIndex: Int
    @Published var createWeek: Bool
    @Published var createNewTask: Bool

    init(currentDate: Date = .init(), currentWeek: [Date.WeekDay] = .init(), currentMonth: [Date.WeekDay] = .init(), weekSlider: [[Date.WeekDay]] = [], currentWeekIndex: Int = 1, createWeek: Bool = false, createNewTask: Bool = false) {
        self.currentDate = currentDate
        self.currentWeek = currentWeek
        self.currentMonth = currentMonth
        self.weekSlider = weekSlider
        self.currentWeekIndex = currentWeekIndex
        self.createWeek = createWeek
        self.createNewTask = createNewTask
    }
}

extension DateState: DateModelAcionsProtocol {
    func fetchCurrentWeek() {
        let newWeek = Date.now.fetchCurrentWeek()
        currentWeek = newWeek
        objectWillChange.send()
    }

    func fetchCurrentMonth() {
        let newMonth = Date.now.fetchCurrentMonth()
        currentMonth = newMonth
        objectWillChange.send()
    }

    func paginateWeek() {
        if currentWeekIndex == 0 {
            // 맨 앞 주에 도달했을 때 로직
            let newWeek = (weekSlider.first?.first?.date.createPreviousWeek())!
            weekSlider.insert(newWeek, at: 0)
            currentWeekIndex = 1 // 현재 인덱스 조정
        } else if currentWeekIndex == weekSlider.count - 1 {
            // 맨 끝 주에 도달했을 때 로직
            let newWeek = (weekSlider.last?.last?.date.createNextWeek())!
            weekSlider.append(newWeek)
        }
    }
}
