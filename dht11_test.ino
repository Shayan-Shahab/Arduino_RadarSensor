#include <DHT.h>

DHT dht(7, DHT11); // pin 7, and it's a DHT11 sensor

void setup() {
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  delay(10000); // DHT11 is slow, only ask it once every 2 seconds
  float humidity = dht.readHumidity();
  float temp = dht.readTemperature();

  Serial.print("Temp: ");
  Serial.print(temp);
  Serial.print(" C   Humidity: ");
  Serial.print(humidity);
  Serial.println(" %");
}
