//
//  ComposerView.swift
//  shybee2
//
//  Created by Taehyung Um on 4/15/25.
//
import SwiftUI

struct ComposerView: View {
    @EnvironmentObject var weeklyQuestion: WeeklyQuestion
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage: PostStorage
    @State private var text = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(weeklyQuestion.currentWeekTitle)
                        .font(.custom("SUITE-ExtraBold", size: 15))
                        .foregroundColor(.gray)
                    Text(weeklyQuestion.currentWeekQuestion)
                        .font(.custom("SUITE-ExtraBold", size: 22))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
//                .padding(.vertical, 12)

                ZStack(alignment: .topLeading) {
                    // Placeholder
                    if text.isEmpty {
                        Text("여기에 부끄러웠던 경험을 적어주세요.")
                            .foregroundColor(.gray)
                            .font(.custom("SUITE-Regular", size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                    }

                    // 실제 TextEditor
                    TextEditor(text: $text)
                        .font(.custom("SUITE-Regular", size: 16))
                        .foregroundColor(.primary)
                        .padding(16)
                        .frame(height: 200)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                }
                
//                TextEditor(text: $text)
//                    .font(.custom("SUITE-Regular", size: 16))
//                    .foregroundColor(.primary)
//                    .padding(16)
//                    .frame(height: 200)
//                    .background(Color.clear) // 배경 제거
//                    .scrollContentBackground(.hidden) // 내부 배경 제거 (🔥 중요)

                
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
            .background(Color(hex: "#FFF9F0").ignoresSafeArea())
            
//            .navigationTitle("글쓰기")
            
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {

                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .light)) // 또는 너가 원하는 사이즈
                            .foregroundColor(.primary) // 브랜드 색상
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
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
                    }) {
                        Text("게시")
                            .font(.custom("Regular", size: 18))
                            .foregroundColor(.primary)
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}


#Preview {
    ComposerView(storage: PostStorage())
        .environmentObject(WeeklyQuestion())
}
