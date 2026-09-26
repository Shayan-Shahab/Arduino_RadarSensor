import processing.serial.*;

Serial myPort;
String buffer = "";

int currentAngle = 90;
int currentDistance = -1;
float currentTemp = 0;
float currentHumidity = 0;
int currentLight = 0;

int maxRangeCM = 60; // adjust to taste
float[] hitDist = new float[181];
boolean[] hasHit = new boolean[181];

void setup() {
  size(950, 550);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(0, 20);

  pushMatrix();
  translate(width / 2 - 90, height - 40);
  drawGrid();
  drawSweepLine();
  drawDetections();
  popMatrix();

  drawReadout();
  drawStatsPanel();
}

void serialEvent(Serial p) {
  buffer = p.readStringUntil('\n');
  if (buffer == null) return;
  buffer = buffer.trim();

  String[] parts = split(buffer, ',');
  if (parts.length < 5) return; // malformed/partial packet, skip it

  try {
    currentAngle = int(parts[0]);
    currentDistance = int(parts[1]);
    currentTemp = float(parts[2]);
    currentHumidity = float(parts[3]);
    currentLight = int(parts[4]);
  } catch (Exception e) {
    return;
  }

  if (currentAngle >= 0 && currentAngle <= 180) {
    hasHit[currentAngle] = currentDistance > 0;
    hitDist[currentAngle] = currentDistance;
  }
}

void drawGrid() {
  noFill();
  stroke(0, 255, 0, 120);
  for (int r = 1; r <= 4; r++) {
    float radius = (width * 0.55) * r / 4.0;
    arc(0, 0, radius * 2, radius * 2, PI, TWO_PI);
  }
  line(-width * 0.28, 0, width * 0.28, 0);
  stroke(0, 255, 0, 60);
  for (int a = 0; a <= 180; a += 30) {
    float rad = radians(a);
    line(0, 0, -cos(rad) * width * 0.28, -sin(rad) * width * 0.28);
  }
}

void drawSweepLine() {
  stroke(0, 255, 0);
  strokeWeight(2);
  float rad = radians(currentAngle);
  float len = width * 0.28;
  line(0, 0, -cos(rad) * len, -sin(rad) * len);
}

void drawDetections() {
  noStroke();
  fill(255, 0, 0);
  for (int a = 0; a <= 180; a++) {
    if (hasHit[a] && hitDist[a] < maxRangeCM) {
      float rad = radians(a);
      float scaled = map(hitDist[a], 0, maxRangeCM, 0, width * 0.28);
      float x = -cos(rad) * scaled;
      float y = -sin(rad) * scaled;
      ellipse(x, y, 8, 8);
    }
  }
}

void drawReadout() {
  fill(0, 255, 0);
  textSize(16);
  textAlign(LEFT);
  String distText = currentDistance > 0 ? currentDistance + " cm" : "out of range";
  text("Angle: " + currentAngle + "°   Distance: " + distText, 20, 30);
}

void drawStatsPanel() {
  int panelX = width - 170;
  int panelY = 40;

  fill(0, 255, 0, 30);
  noStroke();
  rect(panelX - 15, panelY - 25, 160, 110, 6);

  fill(0, 255, 0);
  textSize(14);
  textAlign(LEFT);
  text("ENVIRONMENT", panelX, panelY);
  text("Temp:     " + nf(currentTemp, 1, 1) + " C", panelX, panelY + 25);
  text("Humidity: " + nf(currentHumidity, 1, 1) + " %", panelX, panelY + 45);
  text("Light:    " + currentLight + " / 1023", panelX, panelY + 65);
}
