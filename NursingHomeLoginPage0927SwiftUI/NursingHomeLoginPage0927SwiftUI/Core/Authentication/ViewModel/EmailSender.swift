import Foundation

class EmailSender {
    let apiKey = "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"

    func sendInvitationEmail(to recipient: String, inviteCode: String, inviterName: String, completion: @escaping (Bool) -> Void) {
        // Set up the API URL
        guard let url = URL(string: "https://api.sendgrid.com/v3/mail/send") else {
            completion(false)
            return
        }

        // Set up the email content
        let emailContent: [String: Any] = [
            "personalizations": [
                [
                    "to": [["email": recipient]],
                    "subject": "You're Invited to Join Our System!"
                ]
            ],
            "from": ["email": "your-email@example.com", "name": "Your App Name"],
            "content": [
                [
                    "type": "text/plain",
                    "value": """
                    Hi there,

                    You've been invited by \(inviterName) to join our system.

                    Use the following invite code to register: \(inviteCode)

                    Click the link below to start the registration process:
                    [Registration Link]

                    Thank you,
                    Your App Team
                    """
                ]
            ]
        ]

        // Convert email content to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: emailContent) else {
            completion(false)
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending email: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Check the response status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 202 {
                print("Email sent successfully!")
                completion(true)
            } else {
                print("Failed to send email. Response: \(String(describing: response))")
                completion(false)
            }
        }.resume()
    }
}

