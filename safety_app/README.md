# Safety App

A modern Flutter application focused on personal safety features including emergency contacts, gesture recognition, and hidden camera detection.

## Features

### 1. Emergency Setup
- Add and verify emergency contacts via OTP
- Create custom gesture patterns for quick emergency alerts
- Test emergency features in a safe environment

### 2. Hidden Camera Detection
- Scan surroundings for potential hidden cameras
- Real-time signal strength monitoring
- Threat level assessment and recommendations

### 3. Modern UI/UX
- Material 3 design system
- Smooth animations and transitions
- Intuitive navigation
- Dark/Light theme support

## Technical Details

### Architecture
- Feature-first architecture
- BLoC pattern for state management
- Clean separation of concerns

### Key Dependencies
- flutter_bloc: ^8.1.3 (State Management)
- firebase_core: ^2.15.1 (Firebase Core)
- firebase_auth: ^4.9.0 (Authentication)
- cloud_firestore: ^4.9.1 (Database)
- google_sign_in: ^6.1.5 (Google Authentication)
- shared_preferences: ^2.2.1 (Local Storage)
- flutter_secure_storage: ^9.0.0 (Secure Storage)
- sms_autofill: ^2.3.0 (OTP Handling)
- lottie: ^2.6.0 (Animations)
- google_fonts: ^5.1.0 (Typography)

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── splash/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── emergency/
│   └── camera_detection/
└── main.dart
```

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Screenshots

[Add screenshots here once the app is running]

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter Team for the amazing framework
- Material Design Team for the design system
- All contributors and supporters

## Contact

For support or queries:
- Email: support@safetyapp.com
- Website: www.safetyapp.com
