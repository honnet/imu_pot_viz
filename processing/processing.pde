import processing.serial.*;
Serial myPort;

float roll  = 0.0F;
float potA  = 0.0F; // potentiometer
float potB  = 0.0F; // potentiometer


void setup() {
  size(600, 600);

  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[32], 115200);
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


  // Potentiometers line :
  int minPot = 73;                                          // TODO: make it dynamic
  int maxPot = 513;                                         // TODO: make a different one for A & B
  float potAngle = map(potA , minPot,maxPot, 0, -PI/2);     // TODO: fix range (it's not -PI/2)
  int xp = int(cos(potAngle) * norm);
  int yp = int(sin(potAngle) * norm);
  stroke(0, 255, 0); // green
  line(xc,yc , xc+xp,yc+yp);

  minPot = 100;                                             // TODO: make it dynamic
  maxPot = 517;                                             // TODO: make a different one for A & B
  potAngle = map(potB , minPot,maxPot, 0, -PI/2);           // TODO: fix range (it's not -PI/2)
  xp = int(cos(potAngle) * norm);
  yp = int(sin(potAngle) * norm);
  stroke(0, 0, 255); // blue
  line(xc,yc , xc+xp,yc+yp);


  // IMU line:
  stroke(255, 0, 0); // red
  float imuAngle = radians(-roll);
  int xi = int(cos(imuAngle) * norm);
  int yi = int(sin(imuAngle) * norm);
  line(xc,yc , xc+xi,yc+yi);
}

void serialEvent(Serial p)
{
  String incoming = p.readString();

  if ((incoming.length() > 3))
  {
    String[] list = split(incoming, '\t');

    if (list.length > 0)
    {
      roll  = float(list[0]); // Roll  = Z
      potA  = float(list[1]); // potentiometer
      potB  = float(list[2]); // potentiometer
    }
  }
}
