---
description: Explains how to use the Student Robotics servo board as part of the kit
  issued to teams.
layout: docs
title: Servo Board
---
<a href="/images/content/kit/sbv4.png">
	<img src="/images/content/kit/sbv4.png" alt="A photo of a servo board" title="The Servo Board, click to view larger" width="250px" class="right" />
</a>
The Servo Board can be used to control up to 12 RC servos.
Many devices are available that can be controlled as servos, such as RC motor speed controllers, and these can also be used with the board.

Board Diagram
-------------
<img src="/images/content/kit/servo_board_v4_diagram.png" alt="A diagram of a servo board" />

<!--
Indicators
----------

|   LED           | Meaning                | Initial power-up state
|-----------------|------------------------|----------------------
| Power           | The board is powered   | On
-->

Connectors
----------

There are 8 servo connections on the left-side of the board, and 4 on the right. Servo cables are connected vertically, with 0V (the black or brown wire) at the bottom of the board.

For the servo board to operate correctly, you must connect it to the 12V power
rail from the power board. A green LED will light next to the servo board 12V
connector when it is correctly powered.

Case Dimensions
---------------

The case measures 68x68x21mm. Don't forget that the cables will stick out.

Specification
-------------

|  Parameter                               |   Value   |
|------------------------------------------|-----------|
| Number of servo channels                 | 12        |
| Nominal input voltage                    | 11.1V ± 15% |
| Output voltage                           | 5.5V      |
| Maximum total output current [^1]        | 10A       |

[^1]: If the auxiliary input is connected, outputs 8-11 have an independent maximum current.

Designs
-------

You can access the schematics and source code of the firmware on the servo board in the following places.
You do not need this information to use the board but it may be of interest to some people.

* [Full Schematics](/resources/kit/servo-schematic.pdf)
* [Firmware source](https://www.studentrobotics.org/cgit/boards/servo-v4-fw.git/)
* [Hardware designs](https://www.studentrobotics.org/cgit/boards/servo-v4-hw.git/)
