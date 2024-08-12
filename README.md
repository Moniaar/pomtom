# Pomtom 
A minimal pomodoro app that will be your study buddy! :)
![Flutter Timer Logo](assets/logo.png)

- Note: This is my final graduation project with ALX_SE program.
## Getting Started with a preview of the App:

![Device frames](https://github.com/Moniaar/pomtom/assets/139129370/2939f22f-4dea-4bba-a10b-79be0adafa05)

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Configuration](#configuration)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features

- **Simple and Clean UI**: A user-friendly interface that is easy to navigate.
- **Customizable Timers**: Set your own timer durations for different tasks.
- **Multiple Timer Modes**: Supports different timer modes such as countdown, stopwatch, and interval.
- **Notifications**: Get notified when the timer reaches zero, even when the app is in the background.
- **Dark Mode Support**: Automatically adapts to your device’s dark mode settings.
- **Sound Alerts**: Choose from a variety of sound alerts when the timer ends.
- **Pause and Resume**: Easily pause and resume the timer.
- **Flutter Local Notifications**: Integrates with local notifications for timely alerts.
- **Persistence**: Saves timer state across app restarts.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- **Flutter SDK**: Ensure you have Flutter installed on your machine. You can download it from the [official Flutter website](https://flutter.dev/docs/get-started/install).
- **Dart SDK**: Comes bundled with Flutter.
- **IDE**: Use an IDE such as [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with the Flutter and Dart plugins installed.
- **Device/Emulator**: A physical device or emulator to run the app.

### Installation

1. **Clone the Repository**:
   
   ```
   git clone https://github.com/yourusername/flutter_timer_app.git
   cd flutter_timer_app
   ```
2. **Install Dependencies**:
   ```
   flutter pub get
   ```
3. **Run the App**:
   ```
   flutter run
   ```

### Usage
Once the app is running, you can start by setting a timer using the intuitive UI. Choose your desired duration and mode (countdown, stopwatch, etc.), and hit the start button. You can pause, resume, or reset the timer as needed. If enabled, notifications will alert you when the timer reaches zero.

### Screenshots

### Architecture
This Flutter Timer App follows a clean architecture pattern, separating concerns into different layers:

- Presentation Layer: Consists of the UI components, widgets, and state management.
- Domain Layer: Contains business logic and entities.
- Data Layer: Handles data persistence and retrieval.
The app uses the Provider package for state management and Flutter Local Notifications for notifications.

### Configuration
To customize the app further, you can modify the following configuration files:

lib/config/constants.dart: Contains constant values used across the app.
lib/config/themes.dart: Manages the theming of the app.
pubspec.yaml: Lists all dependencies and assets.

### Testing
The app includes unit tests and widget tests to ensure the functionality of various components:

- Unit Tests: Tests individual units of code such as functions or methods.
- Widget Tests: Tests UI components and their interactions.
To run the tests, use the following command:
```
flutter test
```

## Contributing
Contributions are welcome! If you’d like to contribute, please fork the repository and create a pull request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the Project
2. Create your Feature Branch (git checkout -b feature/AmazingFeature)
3. Commit your Changes (git commit -m 'Add some AmazingFeature')
4. Push to the Branch (git push origin feature/AmazingFeature)
5. Open a Pull Request


### Checklist:
- Make the clock work in sync with the circle layout ✔️
- Make the user choose cutsom time to foucs with ✔️
- Enhance the timer UI --> Change "foucs timer" to Pomtom with unique font and add some plugins.
- Make the AI Actually work ✔️
- Remove the Settings button ✔️
- Add gradiant to the balls on main welcome page
- Enhance the Chatbot UI
- Move the moon icon from its position
- Add a welcome page to show up once when the user installs the app, it should be the logo and name of the App
- put a bar on the bottom of the app with 2 icons to navigate with ✔️
- The study buddy assistance on the 2nd page will be free for now, so make it work by any way you like 
- A window that will ask you if you want to join the AI premium feature at first or not, once answered yes it won't appear again 🔜
- Do all this with the light theme as well ✔️

---

## Premium features functions (Future functionalities coming soon):
1. Study tracker
2. Full access to AI (For now it's free all time) 
3. Payment methods
4. Multiple widgets for each section above


#### What I learned during the debugging phase:
- The debug console is your best friend when the app can't build when you run it.
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### License
This project is licensed under the MIT License - see the LICENSE file for details.

### Contact
Omnia Ahmed Abd Elgader
[Your Email Address]
[Your LinkedIn Profile]
[Your GitHub Profile]
