//
//  ComposerView.swift
//  shybee2
//
//  Created by Taehyung Um on 4/15/25.
//
import SwiftUI
// SwiftUI는 하나의 '프레임워크'

struct ComposerView: View {
    @EnvironmentObject var weeklyQuestion: WeeklyQuestion
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage: PostStorage
    @State private var text = ""
    // 이 view에서 사용할 데이터 변수를 미리 선언
    
    var body: some View {
        NavigationView {
            // 여기서 NavigationView를 쓴 이유는 새로운 Navigation 흐름을 만들기 위함이 아니라
            // .sheet 위에 툴바를 얹기 위해서!
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(weeklyQuestion.currentWeekTitle)
                        .font(.custom("SUITE-ExtraBold", size: 15))
                        .foregroundColor(.secondary)
                    //                                            .background(Color.red.opacity(0.3)) // 디버깅
                    
                    Text(weeklyQuestion.currentWeekQuestion)
                        .font(.custom("SUITE-ExtraBold", size: 22))
                        .foregroundColor(.primary)
                    //                                            .background(Color.blue.opacity(0.3)) // 디버깅
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                //                .padding(.vertical, 12)
                //                .background(Color.green.opacity(0.1)) // VStack 범위 확인 디버깅 코드
                
                ZStack(alignment: .topLeading) {
                    // Placeholder == 사용자가 입력하기 전까지 임시로 보여주는 안내 텍스트
                    if text.isEmpty {
                        Text("당신의 이야기를 들려주세요")
                            .foregroundColor(.gray)
                            .font(.custom("SUITE-Regular", size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 24)
                    }
                    
                    // 실제 TextEditor
                    TextEditor(text: $text)
                        .font(.custom("SUITE-Regular", size: 16))
                        .foregroundColor(.primary)
                        .padding(16)
                        .frame(height: 200)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                        .onChange(of: text) {
                                if text.count > 200 {
                                    text = String(text.prefix(200))
                                }
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
            .background(Color(hex: "#FFF9F0").ignoresSafeArea())
            
            .toolbar {
                // 취소 버튼
                ToolbarItem(placement: .cancellationAction) {
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.primary)
                    }
                }
                
                // 게시 버튼
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
