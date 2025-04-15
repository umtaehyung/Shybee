import SwiftUI

struct ContentView: View {
    @StateObject var storage = PostStorage()
    @State private var showComposer = false
    @State private var showMypage = false

    var body: some View {
        NavigationView {
            List {
                if storage.posts.isEmpty {
                    Text("아직 작성된 글이 없습니다.")
                        .foregroundColor(.gray)
                        .padding()
                }

                ForEach(storage.posts) { post in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(post.content)
                            .font(.body)

                        Text(formattedDate(post.date))
                            .font(.caption)
                            .foregroundColor(.gray)

                        HStack {
                            Button(action: {
                                storage.toggleLike(for: post)
                            }) {
                                Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            }

                            if post.likes > 0 {
                                Text("\(post.likes)")
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("SHYBEE")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showMypage = true
                    }) {
                        Image(systemName: "person.crop.circle")
                    }
                }

                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showComposer = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                    }
                }
            }
        }
        .sheet(isPresented: $showComposer) {
            ComposerView(storage: storage)
        }
        .sheet(isPresented: $showMypage) {
            MypageView(storage: storage)
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

