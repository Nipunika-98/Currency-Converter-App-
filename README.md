# Currency-Converter-App-
A Flutter application for converting currencies using real-time exchange rates. This app is designed following the MVVM (Model-View-ViewModel) architecture pattern, ensuring clean separation of concerns, better maintainability, and enhanced testability.

# Features
Real-time currency conversion using a chosen currency converter API.
User input for selecting the base currency and entering the amount to convert.
Multiple target currency support: Convert to several selected currencies at once.
Local persistence of user's preferred target currencies.
Delete functionality to remove any saved target currency.
User-friendly UI/UX following a predefined design.

# Architecture Overview
The app is implemented using the MVVM (Model-View-ViewModel) architecture:

Model: Handles data-related operations such as fetching conversion rates from the API and saving user preferences locally.
View: Represents the UI layer. It displays the data and listens for user interactions.
ViewModel: Acts as a bridge between the Model and the View. It manages business logic and state, fetching data from the Model and updating the UI.

Advantages of MVVM:

Separation of concerns: Business logic is separated from UI code, making the app easier to maintain and test.
Scalability: Suitable for larger projects with complex business logic.
Testability: Makes it easier to write unit tests for business logic.

# Project Structure
currency_converter/
│
├── lib/
│   ├── models/              # Data models
│   ├── views/               # UI screens
│   ├── viewmodels/          # ViewModels for business logic and state management
│   ├── services/            # API and local persistence services
│   ├── main.dart            # Main entry point of the app
│   
├── pubspec.yaml             # Project configuration file
└── README.md                # Project documentation

# Prerequisites
Before setting up the project, ensure you have the following:

Flutter SDK (version 3.x or above)
Dart (compatible with your Flutter version)
Android Studio or Visual Studio Code (for Flutter development)
A device or emulator to run the app

# Getting Started
1. Clone the repository:
git clone https://github.com/Nipunika-98/Currency-Converter-App-.git
cd currency_converter

2. Install dependencies:
flutter pub get

3. Enable internet permissions:
For Android: Update AndroidManifest.xml with:
<uses-permission android:name="android.permission.INTERNET"/>

For iOS: Check that the network permissions are enabled in Info.plist.

# Running the App
1. Connect your device or start an emulator.
2. Run the application with the following command:
flutter run

3. The app should open on your device/emulator, ready for use.

# Building the App:
To build the app for release, use:
flutter build apk --release

for iOS:
flutter build ios --release
