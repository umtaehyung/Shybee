import SwiftUI

struct ContentView: View {
    @StateObject var storage = PostStorage()
    @State private var showComposer = false
    @State private var showMypage = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 🐝 SHYBEE 헤더 (로고 + 마이페이지 버튼)
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

                
                // 🌱 주간 질문 블록
                 VStack(alignment: .leading, spacing: 4) {
                     Text("4월 둘째주")
                         .font(.subheadline)
                         .foregroundColor(.gray)
                     Text("부끄러웠던 경험을 공유해주세요.")
                         .font(.title3)
                         .foregroundColor(.primary)
                 }
                 .frame(maxWidth: .infinity, alignment: .leading) // ← 핵심! 가로폭 채우고 왼쪽 정렬
                 .padding(.horizontal, 16)
                 .padding(.vertical, 12)
                
                
                // 📄 카드 리스트
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if storage.posts.isEmpty {
                            Text("아직 작성된 글이 없습니다.")
                                .foregroundColor(.gray)
                                .padding(.top, 80)
                        }

                        // 밑에꺼가 복잡해서 새로 넣은 거임
                        ForEach(storage.posts) { post in
                            PostCardView(post: post) {
                                storage.toggleLike(for: post)
                            }
                        }
                        
                    }
                    .padding(.top)
                }

                .overlay(
                    ZStack {
                        // 💨 블러 박스 (하단에서 위로)
                        VStack {
                            Spacer()
                            VisualBlurBox()
                                .frame(height: 200)
                                .allowsHitTesting(false)
                        }
                        .ignoresSafeArea(edges: .bottom)

                        // ➕ 플로팅 버튼 (중앙 아래 고정)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                FloatingButton()
                                Spacer()
                            }
                            .padding(.bottom, 32) // 필요에 따라 조절
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                )
                
                
                
                
            }
            .background(Color(hex: "#FFF9F0").ignoresSafeArea())
            .sheet(isPresented: $showComposer) {
                ComposerView(storage: storage)
            }
            .sheet(isPresented: $showMypage) {
                MypageView(storage: storage)
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

//PostCardView 컴포넌트 정의
struct PostCardView: View {
    let post: Post
    let toggleLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(post.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 4) {
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
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Divider()
                .background(Color(hex: "#DDA693"))

            Text(formattedDate(post.date))
                .font(.caption)
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

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}


// floating button 플로팅 버튼 구성
struct FloatingButton: View {
    var body: some View {
        Button(action: {
            // 액션 연결
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
//        .shadow(radius: 4)
    }
}
