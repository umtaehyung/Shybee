import SwiftUI

struct ContentView: View {
    @EnvironmentObject var weeklyQuestion: WeeklyQuestion
    @StateObject var storage = PostStorage()
    @State private var showComposer = false
    @State private var showMypage = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // SHYBEE 헤더 (로고 + 마이페이지 버튼)
                HStack {
                    Image("shybee_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 124, height: 24) // 피그마 기준 사이즈로 고정
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: {
                        showMypage = true
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(Color(hex: "#DDA693"))
                            .padding(.trailing, 16)
                    }
                }
                .padding(.top, 12)
                
                
                // 주간 질문 블록
                VStack(alignment: .leading, spacing: 4) {
                    Text(weeklyQuestion.currentWeekTitle)
                        .font(.custom("SUITE-ExtraBold", size: 15))
                        .foregroundColor(.gray)
                    Text(weeklyQuestion.currentWeekQuestion)
                        .font(.custom("SUITE-ExtraBold", size: 22))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // ← 핵심! 가로폭 채우고 왼쪽 정렬
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                
                // 카드 리스트
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if storage.posts.isEmpty {
                            Text("아직 작성된 글이 없습니다.")
                                .foregroundColor(.gray)
                                .padding(.top, 80)
                        }
                        
                        // 밑에꺼가 복잡해서 새로 넣은 거임;;;
                        ForEach(storage.posts) { post in
                            PostCardView(post: post, showLike: true) {
                                storage.toggleLike(for: post)
                            }
                        }
                    }
                    .padding(.top)
                }
                
                // 블러 + 버튼
                .overlay(
                    ZStack {
                        // 블러 박스 (하단에서 위로)
                        VStack {
                            Spacer()
                            VisualBlurBox()
                                .frame(height: 200)
                                .allowsHitTesting(false)
                        }
                        .ignoresSafeArea(edges: .bottom)
                        
                        // 플로팅 버튼 (중앙 아래 고정)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                FloatingButton(showComposer: $showComposer)
                                Spacer()
                            }
                            .padding(.bottom, 32) // 필요에 따라 조절
                        }
                    }
                        .ignoresSafeArea(edges: .bottom)
                )
            }
            
            // 배경색
            .background(Color(hex: "#FFF9F0").ignoresSafeArea())
            
            // 모달 시트를 띄우는 역할
            .sheet(isPresented: $showComposer) {
                ComposerView(storage: storage)
            }
            .sheet(isPresented: $showMypage) {
                MypageView(storage: storage)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WeeklyQuestion())
}
