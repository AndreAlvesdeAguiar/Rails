//@@@@@@@@@@@@@@@@@@@@@@@@@@---INCLUSÃO DAS BIBLIOTECAS---@@@@@@@@@@@@@@@
#include <WiFi.h>
#include <HTTPClient.h>

// WIFI information for connection
const char* ssid = "Okura&Aguiar";
const char* password = "*welcome03";
//
#include <DHT.h>
#define DHTTYPE DHT22   // DHT 11
// DHT Sensor
const int DHTPin = 25;
// Initialize DHT sensor.
DHT dht(DHTPin, DHTTYPE);

// Temporary variables
int temperture;


// Port 80 is used since its default port for HTTP
WiFiServer server(80);

// Variable to store the HTTP request
String header;

// Current time
unsigned long currentTime = millis();
// Previous time
unsigned long previousTime = 0;
// Define timeout time in milliseconds
const long timeoutTime = 2000;

const int LED_BUILTIN = 27;
//const int output27 = 27;
/* Attaches content and title to a POST request to be sent to Ruby server
   @params
   String content : string value which will be written into
                    the post on the ruby server
   String title : Title of the post made on the website
*/

void sendToBlog(String content, String title) {

  HTTPClient http;

  // Begins HTTP connection to the ruby server
  http.begin("http://192.168.20.21:3000/posts");
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");

  // Creates POST request string with the custom content attached
  String postData = "post[title]=" + title + "&post[content]=" + content;

  // Sends POST request to RUBY server
  int httpCode = http.POST(postData);
  Serial.println(httpCode);

  http.end();
}


void setup() {
  // Init baud rate
  Serial.begin(115200);
  //
  dht.begin();
  // Init on board LED which is active LOW
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);

  // Connect to Wi-Fi network with SSID and password
  Serial.print("Connecting to ");
  Serial.print(ssid);

  // Start Connection
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  // Print local IP address and start web server
  Serial.println("");
  Serial.println("Connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  server.begin();
}

void loop() {
  // Checks for incoming clients
  WiFiClient client = server.available();

  char temperture = dht.readTemperature();

  // State machine is used to check device state
  // and to perform appropriate functions

  if (client) {
    // Reveals new client connection
    Serial.println("New Client.");

    String currentLine = "";
    currentTime = millis();
    previousTime = currentTime;

    // Loop checks if client is connected and the timout time hasnt expired
    while (client.connected() && currentTime - previousTime <= timeoutTime) {

      currentTime = millis();

      if (client.available()) {
        // Reads data sent from client and stores in header variable
        char c = client.read();
        Serial.write(c);
        header += c;
        if (c == '\n') {

          // Sends client connection info
          if (currentLine.length() == 0) {
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/json");
            client.println("Connection: close");
            client.println();

            // Checks which route has been requested by the client
            if (header.indexOf("GET /LED/on") >= 0) {

              // Turns on LED and sends JSON data to Server
              Serial.println("Turning LED on");
              client.println("{\"Rec\": \"LEDon\"}");
              digitalWrite(LED_BUILTIN, LOW);

              // Creates new blog post saying LED has been turned on
              sendToBlog("Turning LED ON", "LED on");

            } else if (header.indexOf("GET /LED/off") >= 0) {

              // Turns off LED and sends JSON data to Server
              Serial.println("Turning LED off");
              client.println("{\"Rec\": \"LEDoff\"}");
              digitalWrite(LED_BUILTIN, HIGH);

              // Creates new blog post saying LED has been turned off
              sendToBlog("Turning LED OFF", "LED off");

            } else if (header.indexOf("GET /get_data") >= 0) {
              // Creates JSON string based on machine state and accelerometer data
              Serial.println(temperture);

              Serial.println("Sending data");
              char jsonResponse[100];
              //int fanPos = get_motor_position();
              // Sends JSON data to ruby server
              sprintf(jsonResponse, "{\"lastMeasuredTemperature\": \"%d\"}", temperture);
              Serial.println(jsonResponse);
              client.print(jsonResponse);

            } else if (header.indexOf("GET /update") >= 0) {
              // Creates JSON string based on machine state and accelerometer data
              Serial.println("Sending data");
              char jsonResponse[100];
              // Sends JSON data to ruby server
              sprintf(jsonResponse, "{\"updateStatus\": \"success\"}");
              Serial.println(jsonResponse);
              client.print(jsonResponse);

              //*machineState = STATE_SEND_RESQUEST;
            }


          } else {
            currentLine = "";
          }
        } else if (c != '\r') {
          currentLine += c;
        }

      }
    }
    header = "";
    // Close the connection
    client.stop();
    Serial.println("Client disconnected.");
    Serial.println("");
  }
}
