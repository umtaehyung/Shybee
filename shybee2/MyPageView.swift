//
//  MyPageView.swift
//  shybee2
//
//  Created by Taehyung Um on 4/15/25.
//
import SwiftUI

struct MypageView: View {
    @ObservedObject var storage: PostStorage
    @Environment(\.dismiss) var dismiss
    private let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"

    var body: some View {
        NavigationView {
            List {
                ForEach(storage.posts.filter { $0.authorID == deviceID }) { post in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(post.content)
                            .font(.body)

                        Text(formattedDate(post.date))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
                .onDelete(perform: deletePost)
            }
            .navigationTitle("내 글")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .automatic) {
                    EditButton()
                }
            }
        }
    }

    

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

