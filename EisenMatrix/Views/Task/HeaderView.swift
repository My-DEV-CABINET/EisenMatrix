//
//  HeaderView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/19/24.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var dateContainer: DateContainer<DateIntent, DateModel>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Text(dateContainer.model.currentDate.format("MMMM"))
                    .foregroundStyle(.blue)

                Text(dateContainer.model.currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            }
            .font(.title.bold())

            /// Friday, April 19, 2024
            Text(dateContainer.model.currentDate.format("EEEE, M월 dd일, YYYY년"))
                .font(.system(size: 18, weight: .semibold, design: .default))
                .textScale(.secondary)
                .foregroundStyle(.gray)

            TabView(selection: $dateContainer.model.currentWeekIndex) {
                ForEach($dateContainer.model.weekSlider.indices, id: \.self) { index in
                    WeekView(dateContainer: dateContainer, week: dateContainer.model.weekSlider[index])
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
            .onChange(of: dateContainer.model.currentWeekIndex) { _, _ in
                dateContainer.applyIntent(intent: .paginateWeek)
            }
        }
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing, content: {
            // Do Somethings
        })
        .padding(15)
        .background(.white)
        .onChange(of: dateContainer.model.currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (dateContainer.model.weekSlider.count - 1) {
                dateContainer.model.createWeek = true
            }
        }
    }
}
