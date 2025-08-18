import 'package:flutter/material.dart';
import 'package:yappingtime/auth/auth_service.dart';
import 'package:yappingtime/components/my_button.dart';
import 'package:yappingtime/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailAndPassword(
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
              "Welcome Back, you've been missed!",
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
            SizedBox(height: 25),
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),
            SizedBox(height: 25),
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
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}