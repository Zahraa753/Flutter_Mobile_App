import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool islogin = false;

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Email', emailcontroller.text);
    await prefs.setString('password', passwordcontroller.text);
    await prefs.setBool('isLoggedIn', islogin);
    print(
      'Email: ${emailcontroller.text}, Password: ${passwordcontroller.text}, Logged In: $islogin',
    );
  }
}
