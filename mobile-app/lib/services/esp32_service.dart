import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ESP32Service {
  static const String esp32Url = "http://192.168.1.100/status"; 

  static Future<Map<String, dynamic>> fetchSuitcaseData() async {
    try {
      final response = await http.get(Uri.parse(esp32Url)).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("ESP32 Connection Failed: $e");
    }

    return {
      "status": "disconnected",
      "rssi_distance": null,
      "obstacle_distance": null
    };
  }
}
