import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';  
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await AuthService.checkLoginStatus();

  runApp(MyApp(initialScreen: isLoggedIn ? HomeScreen() : LoginScreen()));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  MyApp({required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suitcase Tracker',
      initialRoute: '/', 
      routes: {
        '/': (context) => initialScreen,
        '/LoginScreen': (context) => LoginScreen(),  
        '/HomeScreen': (context) => HomeScreen(),    
      },
    );
  }
}
