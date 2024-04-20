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
