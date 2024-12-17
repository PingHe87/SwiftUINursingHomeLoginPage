//
//  ContactCard.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactCard: View {
    let contact: Contact // Contact details
    @State private var isShowingDetail = false // 控制详情页的显示状态

    var body: some View {
        HStack(spacing: 15) {
            // 点击头像进入 ContactDetailView
            Button(action: {
                // 修改状态变量，触发跳转
                isShowingDetail = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                }
            }
            .buttonStyle(PlainButtonStyle()) // 移除默认按钮样式
            .background(
                // 隐藏的 NavigationLink，用于触发跳转
                NavigationLink(
                    destination: ContactDetailView(contact: contact),
                    isActive: $isShowingDetail
                ) {
                    EmptyView() // 空视图
                }
                .hidden() // 隐藏 NavigationLink
            )

            // 联系人信息（不可点击）
            VStack(alignment: .leading, spacing: 5) {
                Text(contact.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(contact.email)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            // 聊天按钮
            NavigationLink(destination: ChatView(contact: contact)) {
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Circle().fill(Color.blue.opacity(0.1)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ContactCard_Previews: PreviewProvider {
    static var previews: some View {
        ContactCard(
            contact: Contact(
                id: "1",
                name: "John Doe",
                email: "john@example.com",
                role: "Relative",
                tags: []
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
