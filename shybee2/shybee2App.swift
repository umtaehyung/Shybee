//
//  shybee2App.swift
//  shybee2
//
//  Created by Taehyung Um on 4/15/25.
//

import SwiftUI

@main
struct shybee2App: App {
    @StateObject var weeklyQuestion = WeeklyQuestion() // ✅ 모델 인스턴스 생성

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weeklyQuestion) // ✅ 전역으로 공유
        }
    }
}
