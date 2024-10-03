//
//  InputView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text : String
    let title : String
    let placeholder : String
    var isSecuredField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecuredField{
                SecureField(placeholder, text: $text)
                    .font(.system(size:17))
            }else{
                TextField(placeholder, text: $text)
                    .font(.system(size:17))
            }
            
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
