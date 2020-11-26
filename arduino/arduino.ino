#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

#define BNO055_SAMPLERATE_DELAY_MS (1)

// Check I2C device address and correct line below (by default address is 0x29 or 0x28)
Adafruit_BNO055 bno = Adafruit_BNO055(-1, 0x29);  // id, address

const int LED = 13;
const int pots[] = {A0, A1};


void setup(void)
{
    pinMode(A3, OUTPUT); digitalWrite(A3, HIGH);  // Pin to power the IMU
    pinMode(LED, OUTPUT);

    while(!Serial); // wait
    Serial.begin(115200);

    if(!bno.begin()) {
        while(1) {
            Serial.println("No BNO055 detected!");
            delay(1000);
        }
    }
}

void loop(void)
{
    imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);
    Serial.print( euler.z() ); Serial.print( '\t' );
    Serial.print( analogRead(pots[0])); Serial.print( '\t' );
    Serial.print( analogRead(pots[1])); Serial.print( '\n' );

    delay(BNO055_SAMPLERATE_DELAY_MS);

    static int timeStamp = 0;
    if (millis() - timeStamp > 50) {
        digitalWrite(LED, !digitalRead(LED));
        timeStamp = millis();
    }
}

/*
Orientation conventions:
   - Yaw: 0° to 360° (turning clockwise increases values)
   - Pitch: -180° to +180° (turing clockwise increases values)
   - Roll: -90° to +90° (increasing with increasing inclination)
*/
