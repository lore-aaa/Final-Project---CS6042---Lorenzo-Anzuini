# Final-Project---CS6042---Lorenzo-Anzuini

This is my final project for the CS6042 module

I used Pure Data to make a granular sampler, that can be controlled with three potentiometers. The potentiometers are connected to Pure Data though an Arduino Uno board. The Pure Data patch is also connected to Processing, that generates visuals that get affected by what is happening sonically. Finally, I built a case for the pots, the Arduino and the Breadboard, using the Laser Cutter and the 3D printer.

In order for this to work you need:

PD:
- the pduino external and the comport exernal
- add the patches in the abstraction folder to the paths that PD checks when it starts up

Arduino:
- the Firmata Library https://github.com/firmata/arduino/blob/master/examples/StandardFirmata/StandardFirmata.ino
- the StandardFirmata exapmle from the library uploaded to your board
- three 10k pots connected to the board following the schematics in the Arduino folder of this repository
- an Arduino Uno board or smaller (otherwise it won't fit in the enclosure)
- a 5.5x8.5cm (or smaller) breadboard/prototype board (for the same reason.

Digital Fabrication:
- install the Muli-Regular font (included in the Digital Fabrication folder)
- if you want to print using an Ultimaker2 you can use the .gcode file, otherwise prepare te print for your own     printer using the .stl file
