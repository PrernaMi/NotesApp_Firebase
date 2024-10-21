# Notes App

A simple and intuitive Notes app built with Flutter. This app allows users to create, manage, and store notes in the cloud using Firebase. It also includes user authentication, cloud storage for note data, profile management with profile photo functionality.

## Features

- **User Authentication**
  - Sign up and login using Firebase Authentication.
  - Secure password storage and user account management.

- **Firebase Cloud Firestore**
  - Store, retrieve, and sync notes across devices in real-time.
  - Offline support for viewing and editing notes.

- **Firebase Storage**
  - Upload and store user profile photos.
  - Store attachments or images related to notes.

- **Profile Management**
  - Users can manage their profile, including uploading and updating their profile picture.
  - Edit personal information and settings.

## Tech Stack

- **Flutter**: Front-end framework for building beautiful and responsive UIs for both Android and iOS.
- **Firebase Authentication**: User authentication and account management.
- **Firebase Cloud Firestore**: Real-time database for storing notes and user data.
- **Firebase Storage**: For storing user-uploaded profile photos.

## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/PrernaMi/NotesApp_Firebase/tree/prerna_developer
    ```
2. **Navigate to the project directory**:
    ```bash
    cd notes-app
    ```

3. **Install dependencies**:
    ```bash
    flutter pub get
    ```

4. **Configure Firebase**:
   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Create a new project and add Android and iOS apps.
   - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files and place them in the respective directories.

5. **Run the app**:
    ```bash
    flutter run
    ```

## Getting Started with Firebase

- **Authentication**: Configure authentication methods in the Firebase Console.
- **Firestore**: Set up Firestore rules and create a database for storing notes.
- **Storage**: Configure storage rules for profile photos.
- **Cloud Messaging**: Enable cloud messaging for push notifications.

## Screenshots

* Splash Screen
  
  ![Splash](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/1.jpg)

* Login Page

  ![Splash](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/9.png)

* SignUp Page

  ![Splash](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/10.png)

* Home Screen
  
  ![Home](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/2.jpg)

* Add Note
  
  ![Note Add](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/3.jpg)

* Update Note

 ![Update Note](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/4.jpg)

* Drawer Bar

  ![Drawer](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/5.jpg)

* Change Profile Picture

  ![Profile](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/6.jpg)

* Change Profile Info

  ![ChangeInfo](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/7.jpg)

* Change Password

  ![changePass](https://github.com/PrernaMi/NotesApp_Firebase/blob/prerna_developer/assets/screenshots/8.jpg)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

