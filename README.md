# Nursing Home App

A comprehensive iOS application designed to enhance communication, activity management, and daily organization for elderly residents, staff, and family members in nursing homes.

---

## Features
  
### 1. **Sign-Up and Login**
Seamlessly register and log in to the application:
- Role-based account registration (e.g., Staff, Resident, Relative).
- Role-specific functionalities accessible after login.
- Secure authentication using FirebaseAuth.  
<img width="327" alt="image" src="https://github.com/user-attachments/assets/75b18cad-6d69-4ba8-8e7d-470a7262df5b">
<img width="327" alt="image" src="https://github.com/user-attachments/assets/df54a150-efc3-4fe0-a228-24cb391cbc18">

  
### 2. **Home Page**
The central hub of the app that provides quick access to key features:
- View today's activities.
- Check the current weather with a speech option.
- Navigate to the Contacts, Menu, Calendar, and Chat sections.
    
  <img width="325" alt="image" src="https://github.com/user-attachments/assets/35d60495-7a8b-4479-81b2-6aef7e7d4635">

---

### 3. **Activity Management**
Organized activities for the elderly, categorized for easy navigation:
- Categories: Health Management, Social & Entertainment, Education, Family Interaction, and Daily Affairs.
- Each activity displays details such as the title, date, time, location, and description.
- Integrated speech functionality to read activity details aloud.  
  <img width="328" alt="image" src="https://github.com/user-attachments/assets/6f3943c0-c801-4e49-812e-625e8e7b7248">



---

### 4. **Contacts**
Manage and interact with your contacts efficiently:
- Group contacts into categories like Relatives and Staff.
- Search bar for quickly finding contacts.
- Pending friend requests with the ability to accept or reject them.
- Navigate directly to the chat feature by selecting a contact.  
  <img width="328" alt="image" src="https://github.com/user-attachments/assets/58864a92-c8af-4a93-9ca8-4405163b30cd">


---

### 5. **Chat**
Stay connected through instant messaging:
- One-on-one chat with contacts.
- Easy navigation from the Contacts section.
- Clean and accessible interface designed for elderly users.

---

### 6. **Daily Menu**
View the nursing home's daily meal offerings:
- Categorized by meal times (e.g., breakfast, lunch, dinner).
- Clear and accessible layout for elderly users.

  <img width="328" alt="image" src="https://github.com/user-attachments/assets/0a3021a3-4236-4dee-bd93-41e887310152">


---

### 7. **Emergency Assistance**
Provide quick and accessible help options for users:
- **Call Emergency**: Quickly dial emergency services in case of urgent situations.
- **Contact Nurse**: Directly reach out to the nursing home staff for assistance.
- **Get Help**: Access general help and support for any issues or inquiries.
- Clear and visually distinct buttons for easy identification and interaction.
  
  <img width="327" alt="image" src="https://github.com/user-attachments/assets/ba50d1e0-83b1-469e-83fa-8f6ae1d04a96">


---

### 8. **Calendar (In Development)**
Keep track of events and appointments:
- A visually clean calendar view.
- Highlighted dates for planned activities or events.
- Features are still under development.

---

## Technology Stack

- **Language**: Swift, SwiftUI
- **Backend**: Firebase (Firestore for database, FirebaseAuth for authentication)
- **Frameworks**: CoreLocation, AVFoundation, UIKit, MapKit
- **Platform**: iOS

---

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/PingHe87/SwiftUINursingHomeLoginPage.git
   cd SwiftUINursingHomeLoginPage
   ```
2. Open the .xcodeproj file in Xcode.

3. Install dependencies using CocoaPods (if applicable):

    ```bash
    pod install
    ```
3. Configure Firebase:

   Add your GoogleService-Info.plist file to the project.
4. Build and run the project on a simulator or physical device.
