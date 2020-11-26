import processing.serial.*;
Serial myPort;

float roll  = 0.0F;
float[] pots = {0, 0};        // potentiometers A and B
float[] minPots = {90,  102}; // A B
float[] maxPots = {504, 493}; // A B

void setup() {
  size(600, 600);
  strokeWeight(3);

  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[33], 115200);
  myPort.bufferUntil('\n');
}

void draw() {
  background(0xFF);
  int xc = width / 2;               // x center
  int yc = height / 2;              // y center
  float norm = min(xc, yc) * 2 / 3; // line length

  // circle reference
  stroke(200); // grey
  circle(xc, yc, norm*2);

  // Potentiometers line :
  stroke(0, 255, 0); // green
  for (int i = 0; i < 2; i++) {
    float potAngle = map(pots[i] , minPots[i],maxPots[i], 0, -PI/2);
    int xp = int(cos(potAngle) * norm);
    int yp = int(sin(potAngle) * norm);
    line(xc,yc , xc+xp,yc+yp);
  }

  // IMU line:
  stroke(255, 0, 0); // red
  float imuAngle = radians(-roll);
  int xi = int(cos(imuAngle) * norm);
  int yi = int(sin(imuAngle) * norm);
  line(xc,yc , xc+xi,yc+yi);
}

void serialEvent(Serial p) {
  String incoming = p.readString();

  if ((incoming.length() > 6)) {
    String[] list = split(incoming, '\t');

    if (list.length > 0) {
      roll    = float(list[0]); // Roll  = Z
      pots[0] = float(list[1]); // potentiometer
      pots[1] = float(list[2]); // potentiometer
    }
  }
}
