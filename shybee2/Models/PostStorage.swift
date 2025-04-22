import Foundation
import UIKit

class PostStorage: ObservableObject {
    @Published var posts: [Post] = [] {
        didSet {
            savePosts()
        }
    }

    
//    1.    사용자가 앱을 킴
//    2.    shybee2App.swift → ContentView()를 보여줌
//    3.    @StateObject var storage = PostStorage() → 객체 생성
//    4.    PostStorage의 init() 실행 → loadPosts() 호출
//    5.    저장된 글이 있다면 posts 배열에 채워짐
//    6.    화면에 바로 게시글 카드들 표시됨
    
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

// 여기부터
extension PostStorage {
    func delete(_ post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts.remove(at: index)
        }
    }
}
// 여기까지 마이페이지 삭제 커스텀을 위한 코드


// 마이페이지 뷰, 프리뷰용 샘플 코드
extension PostStorage {
    static var sample: PostStorage {
        let storage = PostStorage()
        storage.posts = [
            Post(id: UUID(), content: "마이페이지에서 보는 샘플 글", date: Date(), likes: 0, isLiked: false, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "두 번째 글도 보여요!", date: Date(), likes: 2, isLiked: true, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "마이페이지에서 보는 샘플 글", date: Date(), likes: 0, isLiked: false, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "두 번째 글도 보여요!", date: Date(), likes: 2, isLiked: true, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "마이페이지에서 보는 샘플 글", date: Date(), likes: 0, isLiked: false, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "마이페이지에서 보는 샘플 글", date: Date(), likes: 0, isLiked: false, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "두 번째 글도 보여요!", date: Date(), likes: 2, isLiked: true, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "마이페이지에서 보는 샘플 글", date: Date(), likes: 0, isLiked: false, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "두 번째 글도 보여요!", date: Date(), likes: 2, isLiked: true, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "마이페이지에서 보는 샘플 글", date: Date(), likes: 0, isLiked: false, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"),
            Post(id: UUID(), content: "두 번째 글도 보여요!", date: Date(), likes: 2, isLiked: true, authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown")
        ]
        return storage
    }
}
