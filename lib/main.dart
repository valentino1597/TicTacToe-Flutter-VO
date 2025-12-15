import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase Configuration - YOUR values
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA-eHmnUMsCtCQBoqvrK6S6uLsKiEZSL3s",
      authDomain: "tictactoe-game-vo.firebaseapp.com",
      projectId: "tictactoe-game-vo",
      storageBucket: "tictactoe-game-vo.firebasestorage.app",
      messagingSenderId: "191046405426",
      appId: "1:191046405426:web:13ba98b24e1cb29d4c9b2b",
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Tic Tac Toe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    if (authService.currentUser != null) {
      return const GameScreen();
    } else {
      return const LoginScreen();
    }
  }
}