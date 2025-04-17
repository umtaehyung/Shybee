//
//  WeeklyQuestion.swift
//  shybee2
//
//  Created by Taehyung Um on 4/17/25.
//
import Foundation
import SwiftUI

class WeeklyQuestion: ObservableObject {
    @Published var currentWeekTitle: String = "4월 둘째주"
    @Published var currentWeekQuestion: String = "부끄러웠던 경험을 공유해주세요."
}
