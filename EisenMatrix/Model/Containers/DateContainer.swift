//
//  DateContainer.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import Foundation

final class DateContainer<Intent, Model>: ObservableObject {
    @Published var model: DateModel

    init(model: DateModel) {
        self.model = model
    }

    func applyIntent(intent: DateIntent) {
        switch intent {
        case .paginateWeek:

            if model.currentWeekIndex == 0 {
                // 맨 앞 주에 도달했을 때 로직
                let newWeek = (model.weekSlider.first?.first?.date.createPreviousWeek())!
                model.weekSlider.insert(newWeek, at: 0)
                model.currentWeekIndex = 1 // 현재 인덱스 조정
            } else if model.currentWeekIndex == model.weekSlider.count - 1 {
                // 맨 끝 주에 도달했을 때 로직
                let newWeek = (model.weekSlider.last?.last?.date.createNextWeek())!
                model.weekSlider.append(newWeek)
            }
        }
    }
}
