//
//  ContactDetailView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    
    var body: some View {
        VStack(spacing: 20) {
            Text(contact.name)
                .font(.largeTitle)
                .bold()
            
            Text(contact.email)
                .font(.body)
                .foregroundColor(.gray)
            
            Text("Role: \(contact.role.capitalized)")
                .font(.headline)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Contact Details")
    }
}
