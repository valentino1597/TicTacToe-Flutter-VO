# Tic Tac Toe - A Flutter Game with Firebase made for Emerging technologies of ITS Surabaya

**Course:** ES234527 – Emerging Technology  
**Semester:** Gasal, 2025/2026  
**Student Name:** Valentin Claude René Oulevey
**Student ID:** [Your ID]  


## 📖 Project Description

For this final project i created a simple Tic Tac Toe game built with Flutter and Firebase Authentication. With the little experience I had with flutter, I found this project challenging and exciting because it allowed me to learn about the creation of applications in general. 
In this app players can register, login, play games, and track their performance on a local leaderboard. 
The game features a clean UI, real-time score tracking, and a local data storage (Firebase asked me to pay for cloud storring).

## ✨ Features

- **User Authentication** - Secure email/password registration and login via Firebase
- **Tic Tac Toe Game** - Fully functional game logic with win/loss/draw detection
- **Score Tracking** - Local storage of wins, losses, and draws
- **Leaderboard** - Rankings display showing player statistics with games, win losses and also draw
- **Qualitative UI** - Clean and intuitive interface
- **Input Validation** - Email format and password length checks
- **Error Handling** - Clear error messages for authentication issues

## 🛠️ Technologies Used

- **Flutter** (latest stable version) - UI framework
- **Firebase Authentication** - User account management
- **Provider** - State management
- **SharedPreferences** - Local data
- **Dart** - Programming language

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  provider: ^6.1.2
  shared_preferences: ^2.2.2
```

## 🚀 Installation & Setup

- Flutter SDK installed
- Chrome browser (for web deployment)
- Firebase account

### Step 1: Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/tictactoe-flutter-game.git
cd tictactoe-flutter-game
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Firebase Configuration

1. Create a Firebase project at https://console.firebase.google.com/
2. Enable Email/Password authentication
3. Add a Web app to your Firebase project
4. Copy your Firebase configuration
5. Update `lib/main.dart` with your Firebase config:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_AUTH_DOMAIN",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID",
  ),
);
```

### Step 4: Run the Application
```bash
flutter run -d chrome
```

## 📸 Screenshots

### Login Screen
![Login Screen](screenshots/login.png)

### Registration Screen
![Registration Screen](screenshots/register.png)

### Game Screen
![Game Screen](screenshots/game.png)

### Leaderboard
![Leaderboard](screenshots/leaderboard.png)

## 🎮 How to Use TicTacToe_Game

1. **Register** - Create a new account with username, email, and password
2. **Login** - Sign in with your credentials
3. **Play** - Click on cells to place X's and O's alternately
4. **Track Progress** - View your wins, losses, and draws at the top
5. **View Leaderboard** - Click the leaderboard icon to see rankings
6. **New Game** - Click "New Game" button to reset the board
7. **Logout** - Click the logout icon to sign out

## 🏗️ Project Structure

lib/
├── main.dart                    # App entry point & Firebase initialization
├── models/
│   ├── game_model.dart          # Game logic and state management
│   └── user_model.dart          # User statistics data model
├── screens/
│   ├── login_screen.dart        # Login UI
│   ├── register_screen.dart     # Registration UI
│   ├── game_screen.dart         # Tic Tac Toe game interface
│   └── leaderboard_screen.dart  # Rankings display
└── services/
    ├── auth_service.dart        # Firebase authentication handling
    └── storage_service.dart     # Local data persistence

## 🎯 Implementation Details

### Game Logic
- 3x3 grid with 9 cells
- Players alternate between X and O, the player that register plays X
- Win detection for rows, columns, and diagonals
- Draw detection when board is full

### Authentication
- Firebase Auth for secure user management
- Email/password validation
- Error handling for invalid credentials
- Persistent login sessions

### Data Storage
- Local storage using SharedPreferences (due to Firestore billing requirements)
- Persistent score tracking across sessions
- Leaderboard sorted by wins and win rate

## 🧪 Testing

The application has been tested for:
- ✅ User registration with various inputs
- ✅ Login with correct/incorrect credentials
- ✅ Game win conditions (all 8 patterns)
- ✅ Draw condition
- ✅ Score persistence after app restart
- ✅ Leaderboard sorting accuracy

## 🚧 Limitations & Future Improvements

### Current Limitations:
- Local leaderboard only (not shared across devices)
- Single-player mode (play against yourself, or with a friend obviously)
- No AI opponent.

### Potential Enhancements:
- Add Firestore for cloud-based leaderboard, by resolving the billing problem
- Implement AI opponent with difficulty levels, so that there is a real solo mode. 
- Add multiplayer mode with real-time sync.
- Include sound effects and animations.
- Add profile pictures and user customization.
- An even more detailed interface.

## 🎓 Learning Outcomes

Through this project, I learned:
- Game logic, that can be put as .dart 
- Flutter UI development and widget composition
- Firebase Authentication integration
- State management with Provider
- Local data persistence strategies
- Form validation and error handling
- Git version control and project organization

## 📝 Notes

**Why Local Storage Instead of Firestore?**  
Firebase Firestore requires billing to be enabled. To avoid potential charges and simplify development, I implemented local storage using SharedPreferences. This still demonstrates data persistence and leaderboard functionality while staying within the free tier.
