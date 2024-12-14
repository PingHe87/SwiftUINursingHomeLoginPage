//
//  RegistrationView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/14/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = "" // 输入的邮箱
    @State private var inviteCode = "" // 输入的邀请码
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isInviteValid = false // 标记邀请码验证是否成功
    @State private var showAlert = false
    @State private var alertMessage = ""

    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode // 处理返回导航

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 顶部间距
                Spacer().frame(height: 20)

                // 输入邮箱
                InputView(text: $email,
                          title: "Email",
                          placeholder: "Enter your email")
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disabled(isInviteValid) // 验证成功后不可编辑
                    .opacity(isInviteValid ? 0.5 : 1.0)

                // 输入邀请码
                InputView(text: $inviteCode,
                          title: "Invite Code",
                          placeholder: "Enter your invite code")
                    .disabled(isInviteValid) // 验证成功后不可编辑
                    .opacity(isInviteValid ? 0.5 : 1.0)

                // 验证按钮
                if !isInviteValid {
                    Button(action: {
                        Task {
                            do {
                                // 验证邮箱和邀请码是否匹配
                                try await authViewModel.validateInviteCodeWithEmail(inviteCode, email: email)
                                isInviteValid = true
                                alertMessage = "Invite code validated successfully!"
                                showAlert = true
                            } catch {
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }) {
                        Text("Validate Invite Code")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(email.isEmpty || inviteCode.isEmpty)
                    .opacity((email.isEmpty || inviteCode.isEmpty) ? 0.5 : 1.0)
                } else {
                    Text("Invite code validated successfully!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }

                // 用户注册表单，仅在邀请码验证成功后显示
                if isInviteValid {
                    Divider().padding(.vertical, 10) // 添加分割线

                    InputView(text: $firstName,
                              title: "First Name",
                              placeholder: "Enter your first name")

                    InputView(text: $lastName,
                              title: "Last Name",
                              placeholder: "Enter your last name")

                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecuredField: true)

                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecuredField: true)

                    // 注册按钮
                    Button(action: {
                        Task {
                            do {
                                // 完成注册
                                try await authViewModel.createUser(
                                    withEmail: email,
                                    password: password,
                                    firstName: firstName,
                                    middleName: nil,
                                    lastName: lastName,
                                    role: "relative" // 默认角色，可能从邀请码获取
                                )
                                alertMessage = "Registration successful!"
                                showAlert = true
                            } catch {
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }

                Spacer()
            }
            .padding()
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    if alertMessage == "Registration successful!" {
                        // 回到登录界面
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationTitle("Register") // 显示导航标题
        .navigationBarBackButtonHidden(false) // 显示返回按钮
    }

    // 表单验证
    var formIsValid: Bool {
        return !firstName.isEmpty
            && !lastName.isEmpty
            && !password.isEmpty
            && password == confirmPassword
    }
}


#Preview {
    RegistrationView()
}
