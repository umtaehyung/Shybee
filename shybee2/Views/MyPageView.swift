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
                Text("나의 이야기")
                    .font(.custom("SUITE-ExtraBold", size: 24))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                // 리스트 (스와이프 삭제 가능)
                List {
                    ForEach(Array(myPosts.enumerated()), id: \.offset) { index, post in
                        PostCardView(post: post, showLike: false){
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowSeparator(.hidden)
                        // 스와이프 하면 버튼 등장! 버튼을 누르면 pending (삭제 후보로 저장) 되고.
                        // delete confirmation은 true가 되면서 액션시트가 올라온다!
                        .swipeActions(edge: .trailing) {
                            Button {
                                pendingDeleteOffsets = IndexSet(integer: index)
                                showDeleteConfirmation = true
                            } label: {
                                Text("딸기")
                            }
                            .tint(.red)
                        }
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
                .confirmationDialog("삭제??", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                    Button("딸기", role: .destructive) { // 되돌릴 수 없는 행동을 한다는 의미로 지정하는 속성, 버튼을 빨간색으로 표시하고, 접근성 기능이나 voice over에서도 주의가 필요한 버튼으로 인식된다구함ㅋ
                        if let offsets = pendingDeleteOffsets { //삭제하려던 항목의 인덱스가 저장되어있었는지 확인
                            deletePost(at: offsets) //진짜로 삭제하는 함수 호출
                        }
                        pendingDeleteOffsets = nil   //삭제 후에, 삭제 후보군에 잡아두던 것을 비워줌
                    }
                    Button("취소", role: .cancel) {
                        pendingDeleteOffsets = nil //취소 누르면 pending해 놓은걸 초기화
                    }
                }
            }
            .background(Color(hex: "#FFF9F0").ignoresSafeArea())
            
            // 상단 툴바
            .toolbar {
                // 닫기 버튼 (X mark)
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
                            if editMode?.wrappedValue == .inactive {
                                editMode?.wrappedValue = .active
                            } else {
                                editMode?.wrappedValue = .inactive
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
