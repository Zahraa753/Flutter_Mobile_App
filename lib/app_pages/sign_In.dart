import 'package:flutter/material.dart';
import 'package:notes_app/app_pages/home_screen.dart';
import 'package:notes_app/state_management/sign_In_provider.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInProvider(),
      builder: (context, child) {
        final prov = Provider.of<SignInProvider>(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.green[500],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Form(
                key: prov.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 100, color: Colors.green[400]),
                    TextFormField(
                      controller: prov.emailcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: prov.passwordcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[500],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        if (prov.formKey.currentState!.validate()) {
                          // Handle sign in logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signing in...')),
                          );
                          prov.islogin = true;
                          prov.saveData();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
