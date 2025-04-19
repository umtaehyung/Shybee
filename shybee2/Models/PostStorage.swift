import Foundation
import UIKit

class PostStorage: ObservableObject {
    @Published var posts: [Post] = [] {
        didSet {
            savePosts()
        }
    }

    private let key = "posts_data"

    init() {
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


// 마이페이지 뷰, 프리뷰용 샘플 코드
extension PostStorage {
    static var sample: PostStorage {
        let storage = PostStorage()
        storage.posts = [
            Post(id: UUID(), content: "마이페이지에서 보는 샘플 글", date: Date(), likes: 0, isLiked: false, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "두 번째 글도 보여요!", date: Date(), likes: 2, isLiked: true, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown")
        ]
        return storage
    }
}
