#include <Servo.h>
#include <DHT.h>

const int trigPin = 10;
const int echoPin = 11;
const int servoPin = 12;
const int dhtPin = 7;
const int lightPin = A0;

#define DHTTYPE DHT11

Servo myServo;
DHT dht(dhtPin, DHTTYPE);

float cachedTemp = 0;
float cachedHumidity = 0;
unsigned long lastDHTRead = 0;
const unsigned long dhtInterval = 2000; // DHT11 tops out around 1 reading/sec, poll every 2s to be safe

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
  myServo.attach(servoPin);
  dht.begin();
}

void loop() {
  updateEnvironmentReadings(); // non-blocking: only actually reads DHT11 every dhtInterval ms

  for (int angle = 15; angle <= 165; angle++) {
    sweepStep(angle);
  }
  for (int angle = 165; angle >= 15; angle--) {
    sweepStep(angle);
  }
}

void updateEnvironmentReadings() {
  if (millis() - lastDHTRead >= dhtInterval) {
    float h = dht.readHumidity();
    float t = dht.readTemperature(); // Celsius
    if (!isnan(h) && !isnan(t)) {
      cachedHumidity = h;
      cachedTemp = t;
    }
    lastDHTRead = millis();
  }
}

void sweepStep(int angle) {
  myServo.write(angle);
  delay(30); // let the servo settle before measuring
  int distance = getDistanceCM();
  int light = analogRead(lightPin); // 0-1023, higher = brighter (depends on divider wiring)

  Serial.print(angle);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(",");
  Serial.print(cachedTemp);
  Serial.print(",");
  Serial.print(cachedHumidity);
  Serial.print(",");
  Serial.println(light); // newline marks end of one reading (NOT a period - temp/humidity contain decimal points!)
}

int getDistanceCM() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000); // 30ms timeout ~5m max range
  if (duration == 0) return -1; // no echo received (out of range)

  int distance = duration * 0.0343 / 2;
  return distance;
}
