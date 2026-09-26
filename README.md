# Arduino Sensor Radar

## Overview
An Arduino-based radar system that sweeps an ultrasonic distance sensor 
with a servo motor and displays the results as a live radar screen on 
a computer. Extended with temperature, humidity, and light sensors to 
show environmental data alongside the radar sweep.

## Status
🚧 In progress — currently testing individual sensors before combining 
them into the final build.

## Hardware
- Arduino Uno R3
- HC-SR04 ultrasonic distance sensor
- SG90 servo motor
- DHT11 temperature/humidity sensor
- Photoresistor (light sensor)

## Progress
- [x] DHT11 wired and tested standalone
- [x] Photoresistor wired and tested standalone
- [x] Combine both sensors with the radar sketch
- [x] Build the Processing display with sensor stats panel
- [ ] Gluing/Make pretty
- [ ] Record demo video

## Why this project
Wanted a hands-on hardware project to build real embedded systems 
skills — sensor interfacing, timing, and serial communication — as 
part of moving toward hardware-focused engineering roles.
