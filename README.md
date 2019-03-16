# Quantum
3D-printed model of IBM Q System One

OpenSCAD model of a 1cm to 1foot scale model of the IBM Q System One Quantum Computer.


## Print list...

*black filament*
1. base 
2. base_lid 
3. back_box  * print with raft *  
4. top_box  
5. top_box_lid (inverted)   
6. lid (inverted)  
7. lid_lower (inverted)  
8. lid plinth (inverted for smoothness)   

*white filament*  
9. reflector in white (inverted)  
10. reflector_strip in white

*translucent filament*  
11. diffuser in clear filament (inverted) 

Cryostat needs to be a 25mm x 44mm silver tube (I used chrome-plated wardrobe rail)

Glass walls in 1mm acrylic (2 of each size)
front and back: 92 x 81 mm
left and right: 85 x 81 mm

## Exploded view of the printed components

![exploded view](https://github.com/andysc/Quantum/blob/master/SystemQ.png)

## The finished model

![IBM Q System One model](https://github.com/andysc/Quantum/blob/master/IMG_2301.jpeg)

## Electronics 

The top box has a row of 8 neopixels (144 leds/metre) inside, with a Wemos ESP-8266 Arduino controlling it via MQTT over WiFi

![top box detail](https://github.com/andysc/Quantum/blob/master/IMG_2057.jpeg)
