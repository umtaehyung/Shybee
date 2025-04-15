import Foundation
import UIKit

class PostStorage: ObservableObject {
    @Published var posts: [Post] = [] {
        didSet {
            savePosts()
        }
    }

    private let key = "posts_data"
    private let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"

    init() {
        // ✅ 앱 실행 시 UserDefaults 초기화 (임시로 데이터 삭제)
        //UserDefaults.standard.removeObject(forKey: key)
        loadPosts()
    }

    func addPost(_ post: Post) {
        posts.insert(post, at: 0)
    }

    func toggleLike(for post: Post) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[index].isLiked.toggle()
        posts[index].likes += posts[index].isLiked ? 1 : -1
    }

    func deletePost(_ post: Post) {
        posts.removeAll { $0.id == post.id }
    }

    private func savePosts() {
        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadPosts() {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                posts = try JSONDecoder().decode([Post].self, from: data)
            } catch {
                print("❗️디코딩 실패:", error)
                posts = []
            }
        }
    }
}

