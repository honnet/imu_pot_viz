#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

#define BNO055_SAMPLERATE_DELAY_MS (100)

// Check I2C device address and correct line below (by default address is 0x29 or 0x28)
Adafruit_BNO055 bno = Adafruit_BNO055(-1, 0x29);  // id, address

void setup(void)
{
    Serial.begin(115200);
    pinMode(A7, OUTPUT); digitalWrite(A7, HIGH);  // emulated VCC
    pinMode(A6, OUTPUT); digitalWrite(A6, LOW);   // emulated GND

    if(!bno.begin()) {
        while(1) {
            Serial.println("No BNO055 detected... Check wiring or I2C ADDR!");
            delay(BNO055_SAMPLERATE_DELAY_MS);
        }
    }

    bno.setExtCrystalUse(true);                                                             // TODO test without
}

void loop(void)
{
    imu::Vector<3> accel = bno.getVector(Adafruit_BNO055::VECTOR_ACCELEROMETER);

    // http://www.hobbytronics.co.uk/accelerometer-info
    float tilt_x = atan2( accel.y() , sqrt(accel.x()*accel.x() + accel.z()*accel.z()) );
    float tilt_y = atan2( accel.y() , sqrt(accel.x()*accel.x() + accel.z()*accel.z()) );

    Serial.println( tilt_x * (180.0 / M_PI) );                                               // TODO: leave in rad afterward

    delay(BNO055_SAMPLERATE_DELAY_MS);
}


                                                                                            // TODO: try ESP + MPU ?
                                                                                            //       D6 ?

