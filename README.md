# ProgressSoft App Task

## Overview

The **ProgressSoft App Task** is a Flutter application that leverages Firebase as its backend and uses BLoC for state management. The app follows the Clean Architecture pattern and is built using Flutter version 3.22.2.

## Features

- **Settings**: Manage app settings.
- **Authentication**: User login, registration, and profile management.
- **Posts**: View and manage posts.
- **Index**: Core index functionality for navigation.

## Architecture

The app is structured following the Clean Architecture principles:

- **Core**: Contains essential components like Settings and Index.
- **Features**: Includes specific features like Authentication and Posts.
- **Injection Container**: Handles dependency injection.
- **Main**: Entry point for the application.

## Dependencies

The app uses the following packages:

- `equatable`: ^2.0.5
- `dartz`: ^0.10.1
- `bloc`: ^8.1.4
- `shared_preferences`: ^2.2.3
- `http`: ^1.2.2
- `internet_connection_checker`: ^1.0.0+1
- `get_it`: ^7.7.0
- `flutter_bloc`: ^8.1.6
- `flutter_svg`: ^2.0.10+1
- `firebase_auth`: ^4.16.0
- `cloud_firestore`: ^4.14.0
- `firebase_core`: ^2.24.2
- `intl`: ^0.19.0
- `intl_phone_number_input`: ^0.7.4

## Getting Started

1. **Clone the repository:**

   ```
   git clone https://github.com/Huthaifa-Al-Manasrah/progressSoft-App.git
