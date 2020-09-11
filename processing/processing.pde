import processing.serial.*;
Serial myPort;

float angle;


void setup() {
    size(400,200);

    printArray(Serial.list());
    // Open whatever port is the one you're using.
    myPort = new Serial(this, Serial.list()[0], 115200);
    myPort.bufferUntil(lf);
}

void draw() {
    background(0xFF);

    int xc= width / 2;              // x center
    int yc = height / 2;            // y center
    int norm = min(xc, yc) * 2 / 3; // line length
    // zero'ed coordinates:
    int x = cos(angle) * norm;
    int y = sin(angle) * norm;

    line(xc,     yc,        // starting point
         xc + x, yc + y);   // ending point
}

void serialEvent(Serial p) {
    angle = int(p.readString());
    println(angle);
    angle = radian(angle);
}


