//
//  MockBackend.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import Foundation

class MockBackend {
    static let shared = MockBackend()
    
    // 模拟用户数据库
    private var allUsers: [User] = [
        User(id: UUID().uuidString, firstName: "Alice", middleName: nil, lastName: "Smith", email: "alice@example.com", role: "resident"),
        User(id: UUID().uuidString, firstName: "Bob", middleName: nil, lastName: "Johnson", email: "bob@example.com", role: "staff"),
        User(id: UUID().uuidString, firstName: "Charlie", middleName: nil, lastName: "Brown", email: "charlie@example.com", role: "relative")
    ]
    
    // 搜索用户
    func searchUsers(by username: String, completion: @escaping ([User]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // 模拟网络延迟
            let results = self.allUsers.filter {
                $0.fullName.lowercased().contains(username.lowercased())
            }
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    // 模拟发送好友请求
    func sendFriendRequest(to userID: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // 模拟网络延迟
            DispatchQueue.main.async {
                completion(true) // 总是成功
            }
        }
    }
}
