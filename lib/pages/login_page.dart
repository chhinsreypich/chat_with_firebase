// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import "package:chat_with_firebase/services/auth/auth_service.dart";
import "package:chat_with_firebase/components/my_textfield.dart";
import "package:chat_with_firebase/components/my_button.dart";
import "package:flutter/material.dart";

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // tap to go to register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text,
        _pwController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            // welcome back message
            Text(
              "Welcome Back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // email textfield
            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 25),

            // pw textfield
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 25),

            // login button
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),

            const SizedBox(height: 25),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
