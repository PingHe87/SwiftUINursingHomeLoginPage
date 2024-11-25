//
//  AddFriendViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import Foundation

class AddFriendViewModel: ObservableObject {
    @Published var searchResults: [User] = [] // 搜索结果
    @Published var searchText: String = "" // 搜索关键字
    @Published var isLoading: Bool = false // 搜索加载状态
    @Published var requestSent: Bool = false // 请求发送状态
    
    func searchUsers() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        
        MockBackend.shared.searchUsers(by: searchText) { [weak self] results in
            self?.isLoading = false
            self?.searchResults = results
        }
    }
    
    func sendFriendRequest(to userID: String) {
        MockBackend.shared.sendFriendRequest(to: userID) { [weak self] success in
            if success {
                self?.requestSent = true
            }
        }
    }
}
