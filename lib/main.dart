import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:last_minute_driver/app/reports/testpage.dart';

import 'features/user_auth/presentation/pages/home_page.dart';
import 'features/user_auth/presentation/pages/login_page.dart';
import 'features/user_auth/presentation/pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeSprint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        // Use a FutureBuilder to wait for the Firebase Authentication initialization
        future: _auth.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Determine whether the user is authenticated or not
            bool isAuthenticated = snapshot.data != null;
            // Return either LoginPage or HomePage based on authentication
            return isAuthenticated ?  TestPage() : const LoginPage();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(), // Adding the login page route
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}