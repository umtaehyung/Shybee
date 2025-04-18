import SwiftUI

struct MypageView: View {
    @ObservedObject var storage: PostStorage
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    
    @State private var pendingDeleteOffsets: IndexSet? = nil
    @State private var showDeleteConfirmation: Bool = false
    
    
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
                    .onDelete { offsets in
                        
                        withAnimation(nil) {
                            pendingDeleteOffsets = offsets
                            showDeleteConfirmation = true
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color(hex: "#FFF9F0"))
                .environment(\.editMode, editMode)
                .confirmationDialog("이 게시물을 삭제하겠습니까? 이 동작은 취소할 수 없습니다.", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                    Button("삭제", role: .destructive) {
                        if let offsets = pendingDeleteOffsets {
                            deletePost(at: offsets)
                        }
                        pendingDeleteOffsets = nil
                    }
                    Button("취소", role: .cancel) {
                        pendingDeleteOffsets = nil
                    }
                }
            }
            .background(Color(hex: "#FFF9F0").ignoresSafeArea())
            
            // 상단 툴바
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.primary)
                    }
                }
                
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
        MypageView(storage: PostStorage.sample)
    }
}
