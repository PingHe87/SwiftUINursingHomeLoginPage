//
//  ContactDetailView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    @State private var newTag: String = "" // 输入的标签
    @StateObject private var viewModel = ContactsViewModel() // ViewModel

    var body: some View {
        VStack(spacing: 20) {
            // 联系人基本信息
            Text(contact.name)
                .font(.largeTitle)
                .bold()
            
            Text(contact.email)
                .font(.body)
                .foregroundColor(.gray)
            
            Text("Role: \(contact.role.capitalized)")
                .font(.headline)
            
            // 标签管理区域
            VStack(alignment: .leading, spacing: 10) {
                Text("Tags:")
                    .font(.headline)
                
                // 输入框：添加新标签
                HStack {
                    TextField("Enter a tag", text: $newTag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                    
                    Button(action: {
                        guard !newTag.isEmpty else { return }
                        Task {
                            await viewModel.addTag(to: contact.id, tag: newTag)
                            newTag = "" // 清空输入框
                        }
                    }) {
                        Text("Add")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                
                // 已有标签展示
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(contact.tags, id: \.self) { tag in
                            HStack {
                                Text(tag)
                                    .padding(5)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(5)
                                
                                // 删除按钮
                                Button(action: {
                                    Task {
                                        await viewModel.removeTag(from: contact.id, tag: tag)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Contact Details")
    }
}
