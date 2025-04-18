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
    @Environment(\.editMode) var editMode
    private let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    
    var myPosts: [Post] {
        storage.posts.filter { $0.authorID == deviceID }
    }

    var body: some View {
        NavigationView {
            VStack {
                // 상단 타이틀
                VStack {
                    Text("나의 이야기")
                        .font(.custom("SUITE-ExtraBold", size: 24))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // 리스트 (스와이프 삭제 가능)
                List {
                    ForEach(myPosts) { post in
                        PostCardView(post: post, showLike: false) {
                            storage.toggleLike(for: post)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deletePost)
                }
                .listStyle(.plain)
                .background(Color(hex: "#FFF9F0"))
                .environment(\.editMode, editMode)
            }
            .background(Color(hex: "#FFF9F0").ignoresSafeArea())

            // 상단 툴바
            .toolbar {
              // 닫기 버튼
                ToolbarItem(placement: .cancellationAction) {
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.primary)
                    }
                }
                
                // 편집 버튼
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        withAnimation {
                            if editMode?.wrappedValue == .active {
                                editMode?.wrappedValue = .inactive
                            } else {
                                editMode?.wrappedValue = .active
                            }
                        }
                    }) {
                        Text(editMode?.wrappedValue == .active ? "완료" : "편집")
                            .font(.custom("SUITE-Regular", size: 18))
                            .foregroundColor(
                                editMode?.wrappedValue == .active ? Color.primary : Color.blue
                            )
                    }
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
