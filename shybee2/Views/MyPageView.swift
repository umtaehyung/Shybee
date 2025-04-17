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
            VStack{
                VStack{
                    Text("나의 이야기")
                        .font(.custom("SUITE-ExtraBold", size: 24))
                    .foregroundColor(.primary)}
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                
                ScrollView {
                    LazyVStack (spacing: 16){
                        ForEach(storage.posts.filter { $0.authorID == deviceID }) { post in
                            PostCardView(post: post, showLike: false){
                                storage.toggleLike(for: post)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .background(Color(hex: "#FFF9F0").ignoresSafeArea())
            
            // 상단 툴바 영역
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("닫기")
                            .font(.custom("SUITE-Regular", size: 18))
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .automatic) {
                    EditButton()
                }
            }
        }
    }
    
    
    
    func deletePost(at offsets: IndexSet) {
        let myPosts = storage.posts.filter { $0.authorID == deviceID }
        for index in offsets {
            if let originalIndex = storage.posts.firstIndex(where: { $0.id == myPosts[index].id }) {
                storage.posts.remove(at: originalIndex)
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



struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        // 샘플 PostStorage 넣어줘야 함!
        MypageView(storage: PostStorage.sample)
    }
}
