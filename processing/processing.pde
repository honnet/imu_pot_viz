import processing.serial.*;
Serial myPort;

float yaw   = 0.0F;
float pitch = 0.0F;
float roll  = 0.0F;
float pot   = 0.0F; // potentiometer


void setup() {
  size(600, 600);

  //    printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil('\n');
}

void draw() {
  background(0xFF);
  int xc = width / 2;             // x center
  int yc = height / 2;            // y center
  float norm = min(xc, yc) * 2 / 3; // line length

  // circle reference
  stroke(200); // grey
  circle(xc, yc, norm*2);

  // Potentiometer line :
  stroke(0, 0, 255); // blue
  int minPot = 50;
  int maxPot = 513;
  float potAngle = map(pot , minPot,maxPot, 0, -PI/2);
  int xp = int(cos(potAngle) * norm);
  int yp = int(sin(potAngle) * norm);
  line(xc,yc , xc+xp,yc+yp);

  // IMU line:
  stroke(0); // black
  float imuAngle = radians(roll);
  int xi = int(cos(imuAngle) * norm);
  int yi = int(sin(imuAngle) * norm);
  line(xc,yc , xc+xi,yc+yi);

}

void serialEvent(Serial p)
{
  String incoming = p.readString();

  if ((incoming.length() > 0))
  {
    String[] list = split(incoming, '\t');

    if (list.length > 0)
    {
      yaw   = float(list[0]); // Yaw   = X
      pitch = float(list[1]); // Pitch = Y
      roll  = float(list[2]); // Roll  = Z
      pot   = float(list[3]); // potentiometer
    }
  }
}

