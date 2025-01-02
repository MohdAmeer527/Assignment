# Flutter Application Development Assignment

A Flutter application designed to demonstrate API integration, location services, image uploads, and persistent local storage with a user-friendly UI.

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Running the Project](#running-the-project)
- [Directory Structure](#directory-structure)
- [Architecture](#architecture)
- [Permissions](#permissions)
- [License](#license)

## Project Overview
This project fetches and displays user data from an API, handles location services, and enables users to upload images, which are stored locally for persistence across app restarts.

### API Endpoint
```
https://reqres.in/api/users?page=2
```

## Features
- Displays the current latitude, longitude, and address at the top of the screen
- Retrieves and lists user details from the API, including avatars
- Allows image uploads via gallery or camera, replacing the API-provided avatar
- Stores uploaded images locally using Hive 
- Responsive design for various screen sizes
- Implements MVC architecture with GetX for state management

## Prerequisites
Before running the project, ensure the following are installed:
- Git
- Flutter SDK (Version 3.1.0 or later)
- Android Studio or Xcode for emulators
- A connected device or emulator for testing

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/MohdAmeer527/Assignment.git

```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Permissions
- For Android, update AndroidManifest.xml with required permissions for location and storage
- For iOS, update Info.plist with corresponding keys

## Installation

### Run the App on an Emulator or Device
```bash
flutter run
```

### Build APK for Distribution
```bash
flutter build apk --release
```

## Running the Project
1. Location Services: Grant location permissions when prompted to display your current location
2. User Details: API users are listed with their avatars
3. Image Upload: Tap the upload icon next to a user to select an image from the gallery or capture one with the camera
4. Persistence: Uploaded images will replace avatars and persist across app restarts

## Directory Structure
```
/lib
  |-- controllers/       # GetX controllers for business logic
  |-- models/           # Data models
  |-- views/            # UI screens
  |-- network/         # Location and API service layers
  |-- constants/            # Widgets and API Urls
  |-- main.dart         # Application entry point
```

## Architecture
This project follows the MVC architecture:
- **Model**: Data models for users and local storage
- **View**: UI components built with Flutter widgets
- **Controller**: Handles business logic, state management using GetX, and interacts with models and services

## Permissions
This app requires the following permissions:
- **Location**: To fetch and display the user's current location
- **Storage**: To save and retrieve uploaded images locally
- **Camera**: To capture images for upload

Ensure permissions are correctly configured in AndroidManifest.xml and Info.plist.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
