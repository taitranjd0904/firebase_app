import 'package:firebase_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthService authService = new AuthService();
  // DatabaseMethods databaseMethods = new DatabaseMethods();

  signUp() async {
    // if(formKey.currentState.validate()){
    await authService
        .signUpWithEmailAndPassword(
            _emailController.text, _passwordController.text)
        .then((result) {
      if (result != null) {
        // Map<String, String> userDataMap = {
        //   "userName": _nameController.text,
        //   "userEmail": _emailController.text
        // };
        print("Sign Up Successful $result");

        // databaseMethods.addUserInfo(userDataMap);

        // HelperFunctions.saveUserLoggedInSharedPreference(true);
        // HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
        // HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                ElevatedButton(
                  onPressed: signUp,
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
