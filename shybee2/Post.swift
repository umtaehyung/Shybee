//
//  Post.swift
//  shybee2
//
//  Created by Taehyung Um on 4/15/25.
//
import Foundation

struct Post: Identifiable, Codable {
    let id: UUID
    let content: String
    let date: Date
    var likes: Int
    var isLiked: Bool
    let authorID: String
}
