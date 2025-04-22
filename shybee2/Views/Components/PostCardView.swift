//
//  SwiftUIView.swift
//  shybee2
//
//  Created by Taehyung Um on 4/21/25.
//

import SwiftUI

//PostCardView 컴포넌트 정의
struct PostCardView: View {
    let post: Post
    let showLike : Bool
    let toggleLike: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(post.content)
                
                    .font(.custom("SUITE-SemiBold", size: 15))
                    .foregroundColor(.primary)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if showLike {
                    VStack(spacing: 8) {
                        Button(action: {
                            toggleLike()
                        }) {
                            Image(systemName: post.isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(post.isLiked ? .pink : Color(hex: "#DDA693"))
                        }
                        if post.likes > 0 {
                            Text("\(post.likes)")
                            
                                .font(.custom("SUITE-ExtraBold", size: 9))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Divider()
                .background(Color(hex: "#DDA693"))
            
            Text(formattedDate(post.date))
                .font(.custom("SUITE-SemiBold", size: 11))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#DDA693"), lineWidth: 1)
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    //날짜 표시 함수
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

#Preview {
    PostCardView(
        post: Post(id: UUID(), content: "hello", date: Date(), likes: 1, isLiked: false, authorID: "1"), showLike: true, toggleLike: {}
    )
}
