//
//  ComposerView.swift
//  shybee2
//
//  Created by Taehyung Um on 4/15/25.
//
import SwiftUI

struct ComposerView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage: PostStorage
    @State private var text = ""

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $text)
                    .padding()
                    .frame(height: 400)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .onChange(of: text) {
                        if text.count > 200 {
                            text = String(text.prefix(200))
                        }
                    }

                HStack {
                    Spacer()
                    Text("\(text.count)/200")
                        .font(.caption)
                        .foregroundColor(text.count == 200 ? .red : .gray)
                        .padding(.trailing, 16)
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("글쓰기")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("게시") {
                        let newPost = Post(
                            id: UUID(),
                            content: text,
                            date: Date(),
                            likes: 0,
                            isLiked: false,
                            authorID: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
                        )
                        storage.addPost(newPost)
                        dismiss()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}


