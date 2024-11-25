//
//  ContactsViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import Foundation

class ContactsViewModel: ObservableObject {
    @Published var groupedContacts: [String: [Contact]] = [:] 
    @Published var searchText: String = "" {
        didSet {
            filterAndGroupContacts()
        }
    }
    
    private var contacts: [Contact] = []

    init() {
        loadContacts()
    }
    
    private func loadContacts() {

        contacts = [
            Contact(id: UUID().uuidString, name: "Alice Smith", email: "alice@example.com", role: "relative"),
            Contact(id: UUID().uuidString, name: "Bob Johnson", email: "bob@example.com", role: "resident"),
            Contact(id: UUID().uuidString, name: "Charlie Brown", email: "charlie@example.com", role: "staff"),
            Contact(id: UUID().uuidString, name: "David Clark", email: "david@example.com", role: "relative"),
        ]
        filterAndGroupContacts()
    }
    
    private func filterAndGroupContacts() {
        let filtered = searchText.isEmpty
            ? contacts
            : contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
        groupedContacts = Dictionary(grouping: filtered, by: { $0.role.capitalized })
    }
}
