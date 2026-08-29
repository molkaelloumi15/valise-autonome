import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:my_valise/services/auth_service.dart';
import 'login_screen.dart';
import 'dart:convert';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _connectionStatus = "Unknown";
  double _rssiDistance = 0;
  double _obstacleDistance = 0;

  @override
  void initState() {
    super.initState();
    _getConnectionStatus();

    Timer.periodic(Duration(seconds: 2), (timer) {
      _getConnectionStatus();  // Poll every 2 seconds
    });
  }

  Future<void> _getConnectionStatus() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/status')).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _connectionStatus = data["status"];
          _rssiDistance = data["rssi_distance"];
          _obstacleDistance = data["obstacle_distance"];
        });
      } else {
        setState(() {
          _connectionStatus = "Failed to fetch status";
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = "Error: $e";
      });
    }
  }

  void _logout() async {
    await AuthService.logout();
    Get.offAll(LoginScreen()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _logout, 
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/background.jpg',  
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _connectionStatus == "connected" 
                        ? "Your suitcase is just behind you!" 
                        : "Your suitcase is lost!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 300),
                  Text(
                    "RSSI Distance: ${_rssiDistance.toStringAsFixed(2)} cm",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Obstacle Distance: ${_obstacleDistance.toStringAsFixed(2)} cm",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
