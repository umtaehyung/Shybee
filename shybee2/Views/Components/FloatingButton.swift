//
//  FloatingButton.swift
//  shybee2
//
//  Created by Taehyung Um on 4/21/25.
//

import SwiftUI

struct FloatingButton: View {
    @Binding var showComposer: Bool
    var body: some View {
        Button(action: {
            showComposer = true
        }) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#DDA693"))
                    .frame(width: 74, height: 74)
                    .shadow(radius: 4)
                
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(hex: "#FFF9F0"))
            }
        }
    }
}
