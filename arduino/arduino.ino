#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

#define BNO055_SAMPLERATE_DELAY_MS (50)

// Check I2C device address and correct line below (by default address is 0x29 or 0x28)
Adafruit_BNO055 bno = Adafruit_BNO055(-1, 0x29);  // id, address

const int LED = 6;


void setup(void)
{
    pinMode(27, OUTPUT); digitalWrite(27, HIGH);  // Pin to power the IMU
    pinMode(38, OUTPUT); digitalWrite(38, HIGH);  // Pin to power the potentiometer
    pinMode(LED, OUTPUT);

    Serial.begin(115200);
    while(!Serial); // wait
    
    if(!bno.begin()) {
        while(1) {
            Serial.println("No BNO055 detected... Check wiring or I2C ADDR!");
            delay(1000);
        }
    }
    bno.setExtCrystalUse(true); // TODO test both
}

void loop(void)
{
    imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);
    Serial.print( euler.x() ); Serial.print( '\t' ); // TODO: pick only 1
    Serial.print( euler.y() ); Serial.print( '\t' ); // TODO: pick only 1
    Serial.print( euler.z() ); Serial.print( '\t' ); // TODO: pick only 1
    Serial.print( analogRead(A1) ); Serial.print( '\n' );

    delay(BNO055_SAMPLERATE_DELAY_MS);
    digitalWrite(LED, !digitalRead(LED));
}

/*
Orientation conventions:
   - Yaw: 0° to 360° (turning clockwise increases values)
   - Pitch: -180° to +180° (turing clockwise increases values)
   - Roll: -90° to +90° (increasing with increasing inclination)
*/
