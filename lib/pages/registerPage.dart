import 'package:flutter/material.dart';
import 'package:yappingtime/auth/authService.dart';
import 'package:yappingtime/components/myButton.dart';
import 'package:yappingtime/components/myTextfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) {
    final authService = AuthService();
    if (passwordController.text == confirmController.text) {
      try {
        authService.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
    );
      } catch (e) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Passwords do not match"),
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
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 50),
            Text(
              "Let's create account for you!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
            MyTestField(
              hintText: "Email",
              obscureText: false,
              controller: emailController,
            ),
            SizedBox(height: 10),
            MyTestField(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(height: 10),
            MyTestField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: confirmController,
            ),
            SizedBox(height: 25),
            MyButton(text: "Register", onTap: () => register(context)),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
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
