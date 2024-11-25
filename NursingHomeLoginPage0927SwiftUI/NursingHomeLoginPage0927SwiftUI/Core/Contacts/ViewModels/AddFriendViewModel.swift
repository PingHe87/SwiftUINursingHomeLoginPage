//
//  AddFriendViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddFriendViewModel: ObservableObject {
    @Published var searchResults: [User] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var requestSent: Bool = false

    private let db = Firestore.firestore()

    /// 搜索用户
    func searchUsers() async {
        guard !searchText.isEmpty else { return }
        
        // 在主线程更新 isLoading
        DispatchQueue.main.async {
            self.isLoading = true
        }

        do {
            let snapshot = try await db.collection("users")
                .whereField("fullName", isGreaterThanOrEqualTo: searchText)
                .whereField("fullName", isLessThanOrEqualTo: searchText + "\u{f8ff}")
                .getDocuments()

            let users = snapshot.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
            }

            // 在主线程更新 searchResults 和 isLoading
            DispatchQueue.main.async {
                self.searchResults = users
                self.isLoading = false
            }
        } catch {
            print("Error searching users: \(error.localizedDescription)")
            // 确保在主线程关闭加载状态
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }


    /// 发送好友请求
    func sendFriendRequest(to userID: String) async {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No logged-in user.")
            return
        }

        do {
            let userRef = db.collection("users").document(userID)
            try await userRef.updateData([
                "pendingRequests": FieldValue.arrayUnion([currentUserID])
            ])
            
            DispatchQueue.main.async {
                self.requestSent = true
            }
        } catch {
            print("Error sending friend request: \(error.localizedDescription)")
        }
    }
}
