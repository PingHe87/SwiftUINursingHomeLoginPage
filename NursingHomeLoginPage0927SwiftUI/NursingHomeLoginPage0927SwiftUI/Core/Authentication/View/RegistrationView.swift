import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var inviteCode = "" // Invite code field
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isInviteCodeValid = false // State to track invite code validation
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Register")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Form fields
                InputView(text: $email,
                          title: "Email",
                          placeholder: "Enter your email")
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

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

                // Invite Code Field
                ZStack(alignment: .trailing) {
                    InputView(text: $inviteCode,
                              title: "Invite Code",
                              placeholder: "Enter your invite code")
                    
                    // Validation status for invite code
                    if !inviteCode.isEmpty {
                        if isInviteCodeValid {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }

                // Validate Invite Code Button
                Button("Validate Invite Code") {
                    Task {
                        do {
                            try await authViewModel.validateInviteCode(inviteCode)
                            isInviteCodeValid = true
                            alertMessage = "Invite code is valid!"
                            showAlert = true
                        } catch {
                            isInviteCodeValid = false
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(isInviteCodeValid ? Color.gray : Color.blue)
                .cornerRadius(10)
                .disabled(inviteCode.isEmpty || isInviteCodeValid)

                // Sign Up button
                Button(action: {
                    Task {
                        do {
                            // Proceed with registration after invite code validation
                            try await authViewModel.createUser(
                                withEmail: email,
                                password: password,
                                firstName: firstName,
                                middleName: nil,
                                lastName: lastName,
                                role: "relative" // Default role or fetched from invite
                            )
                            showAlert = true
                            alertMessage = "Registration successful!"
                        } catch {
                            showAlert = true
                            alertMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(!formIsValid || !isInviteCodeValid) // Disable until form is valid and invite code is validated
                .opacity(formIsValid && isInviteCodeValid ? 1.0 : 0.5)

                Spacer()
            }
            .padding()
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
    
    /// Form validation logic
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !firstName.isEmpty
            && !lastName.isEmpty
            && !password.isEmpty
            && password == confirmPassword
            && !inviteCode.isEmpty
    }
}

#Preview {
    RegistrationView()
}
