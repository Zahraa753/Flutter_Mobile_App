import 'package:flutter/material.dart';
import 'package:notes_app/app_pages/home_screen.dart';
import 'package:notes_app/app_pages/sign_In.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isLogged = false;
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear previous data for testing purposes
    String? email = prefs.getString('Email');
    String? password = prefs.getString('password');
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    print('Email: $email, Password: $password, Logged In: $isLoggedIn');

    setState(() {
      isLogged = isLoggedIn;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    Future.delayed(const Duration(seconds: 5)).then((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => isLogged == true ? HomeScreen() : Signin(),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/notelogo.png',
          height: 150,
          width: 200,
        ),
      ),
    );
  }
}
