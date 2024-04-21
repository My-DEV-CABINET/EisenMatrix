//
//  Date+Extensions.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

/// Date Extensions Needed for Building UI
extension Date {
    /// Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    /// Checking Whether the Date is Today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Checking if the date is Same Hour
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    
    /// Checking if the date is Past Hours
    var isPast: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }
    
    func fetchCurrentWeek(_ date: Date = .init()) -> [WeekDay] {
        var weekDays: [WeekDay] = []
        var calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: date)

        // Calendar에서 월요일을 주의 시작으로 설정
        calendar.firstWeekday = 2
        
        // 주어진 날짜에서 이번 주 월요일을 찾기
        let currentWeekday = components.weekday!
        let daysToMonday = (currentWeekday - calendar.firstWeekday + 7) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToMonday, to: date)!

        // 월요일부터 일주일 간의 날짜 계산
        for day in 0 ..< 7 {
            // 옵셔널 바인딩...
            if let weekdayDate = calendar.date(byAdding: .day, value: day, to: startOfWeek) {
                weekDays.append(.init(date: weekdayDate))
            }
        }
        
        return weekDays
    }
    
    func fetchCurrentMonth(for date: Date = .init()) -> [WeekDay] {
        var weeks: [WeekDay] = []
        let date = Date(timeIntervalSinceNow: 0)
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko")

        // 여기에 기입하지 않은 날짜는 1로 초기화가 된다
        let components = calendar.dateComponents([.year, .month], from: date)

        // day를 기입하지 않아서 현재 달의 첫번쨰 날짜가 나오게 된다
        let startOfMonth = calendar.date(from: components)!
        let comp1 = calendar.dateComponents([.day, .weekday, .weekOfMonth], from: startOfMonth)

        let nextMonth = calendar.date(byAdding: .month, value: +1, to: startOfMonth)

        let endOfMonth = calendar.date(byAdding: .day, value: -1, to: nextMonth!)
                
        let comp2 = calendar.dateComponents([.day, .weekday, .weekOfMonth], from: endOfMonth!)
        let weekArr = calendar.shortWeekdaySymbols

        if let weekday = comp1.weekday, let weekday2 = comp2.weekday {
            print(weekArr[weekday - 1])
            print(weekArr[weekday2 - 1])
        }

        for index in (comp1.day! ... comp2.day!) {
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfMonth) {
                weeks.append(.init(date: weekDay))
            }
        }
        
        return weeks
    }

    /// Fetching Week Based on given Date
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else { return [] }
        
        /// Iterations to get the Full Week
        for index in (0 ..< 7) {
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    /// Creating Next Week, based on the Last Current Week's Date
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else { return [] }
        return fetchWeek(nextDate)
    }
    
    /// Creating Previous Week, based on the First Current Week's Date
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else { return [] }
        return fetchWeek(previousDate)
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
    
    static func currentKoreanDate() -> Date {
        let today = Date()
        let timezone = TimeZone.autoupdatingCurrent
        let secondsFromGMT = timezone.secondsFromGMT(for: today)
        let localizedDate = today.addingTimeInterval(TimeInterval(secondsFromGMT))
        return localizedDate
    }
}
