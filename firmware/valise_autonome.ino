#include <WiFi.h>
#include <WebServer.h>
#include <esp_wifi.h>

// Wi-Fi credentials (AP mode)
const char *ssid = "Suitcase_AP";
const char *password = "12345678";

WebServer server(80); // HTTP server on port 80

// Ultrasonic sensor pins
#define TRIG_FRONT 4
#define ECHO_FRONT 2

const float TOLERANCE = 15.0; // in cm

// === Init ultrasonic pins ===
void initUltrasonic() {
  pinMode(TRIG_FRONT, OUTPUT);
  pinMode(ECHO_FRONT, INPUT);
}

// === Measure distance using ultrasonic sensor ===
float mesurerDistance() {
  digitalWrite(TRIG_FRONT, LOW);
  delayMicroseconds(5);
  digitalWrite(TRIG_FRONT, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_FRONT, LOW);

  long duration = pulseIn(ECHO_FRONT, HIGH, 30000);  // timeout = 30ms
  if (duration == 0) return -1;  // No echo

  float distance = duration * 0.034 / 2;  // cm
  return distance;
}

// === Handle GET /status ===
void handleStatus() {
  wifi_sta_list_t stationList;
  String message = "No devices connected";
  float rssiDistance = 0;
  float obstacleDistance = -1;

  if (esp_wifi_ap_get_sta_list(&stationList) == ESP_OK) {
    if (stationList.num > 0) {
      int rssi = stationList.sta[0].rssi;
      rssiDistance = pow(10, (-50 - rssi) / (10 * 2.0)) * 100; // in cm

      obstacleDistance = mesurerDistance();  // Measure distance using ultrasonic sensor
    }
  }

  // Logic for real obstacle detection: if obstacle distance is smaller than RSSI distance
  bool isRealObstacle = (obstacleDistance > 0 && obstacleDistance < rssiDistance);

  // Create JSON response with status, RSSI-based distance, and obstacle distance (only send if real obstacle)
  String jsonResponse = "{";
  jsonResponse += "\"status\": \"connected\","; // assume always connected for simplicity
  jsonResponse += "\"rssi_distance\": " + String(rssiDistance) + ",";

  // Only send obstacle distance if it's a real obstacle
  if (isRealObstacle) {
    jsonResponse += "\"obstacle_distance\": " + String(obstacleDistance);
  } else {
    jsonResponse += "\"obstacle_distance\": -1";  // Indicate no real obstacle
  }

  jsonResponse += "}";

  // Allow CORS for Flutter Web
  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.sendHeader("Access-Control-Allow-Methods", "GET");
  server.sendHeader("Access-Control-Allow-Headers", "Content-Type");

  server.send(200, "application/json", jsonResponse);  // Send JSON response
}

// === Setup ===
void setup() {
  Serial.begin(115200);

  // Start Wi-Fi in Access Point mode
  WiFi.softAP(ssid, password);
  Serial.println("✅ ESP32 Access Point started!");
  Serial.print("📡 IP Address: ");
  Serial.println(WiFi.softAPIP());

  initUltrasonic();

  // Setup HTTP route
  server.on("/status", handleStatus);
  server.begin();
  Serial.println("🌐 Web server started.");
}

// === Loop ===
void loop() {
  // Handle incoming HTTP requests
  server.handleClient();

  // Continuously measure and log RSSI and obstacle distance to serial monitor
  wifi_sta_list_t stationList;
  float rssiDistance = 0;
  float obstacleDistance = -1;

  if (esp_wifi_ap_get_sta_list(&stationList) == ESP_OK) {
    if (stationList.num > 0) {
      int rssi = stationList.sta[0].rssi;
      rssiDistance = pow(10, (-50 - rssi) / (10 * 2.0)) * 100; // in cm

      obstacleDistance = mesurerDistance();  // Measure distance using ultrasonic sensor
    }
  }

  // Log data to serial monitor
  Serial.print("📶 RSSI: ");
  Serial.print(rssiDistance);
  Serial.print(" cm  |  Obstacle Distance: ");
  Serial.print(obstacleDistance);
  Serial.println(" cm");

  delay(1000); // Update every second
}


