import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_valise/services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    bool success = await AuthService.login(
      emailController.text,
      passwordController.text,
    );
    setState(() => _loading = false);

    if (success) {
      Get.off(HomeScreen()); 
    } else {
      Get.snackbar("Error", "Invalid email or password",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(  
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60), 
            Text("Welcome!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Login to track your suitcase.", style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            _loading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor: Colors.blueAccent),
                      child: Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}

}
