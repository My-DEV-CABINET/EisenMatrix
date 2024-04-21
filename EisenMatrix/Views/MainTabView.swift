//
//  TabView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView.build()
                .tabItem {
                    Image(systemName: "checklist")
                }

            ChartView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                }

            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
        .font(.headline)
    }
}
