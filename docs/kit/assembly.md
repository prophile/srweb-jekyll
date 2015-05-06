---
description: Instructions on how to put the various modules and boards together.
layout: docs
title: Kit Assembly
---
The Student Robotics kit contains a number of separate modules which must be connected together to be usable to control your robot.

Preparation
-----------

The power board contains a connector for an external On|Off switch.
If you do not intend to connect a switch then you must still make this connection.
You can do this by connecting a short loop of wire between the two terminals of a suitable CamCon and placing it in the external On|Off port.

[Connections](#Connections) {#Connections}
-----------

Each of the modules in the kit needs to be provided with both a control signal and power in order to operate.
All the boards use USB to connect to the [Brain Board](/docs/kit/brain_board) so it can tell them what to do.
If you run out of USB ports on the Brain Board itself, then you can use the provided USB hubs to provide more ports.

Most of the boards (with the exception of the [Ruggeduino](/docs/kit/ruggeduino)) also need an additional power connection.
This should be provided from the [Power Board](/docs/kit/power_board).

The following table summarises the connections which need to be made for each board.

Board                                   | Power
----------------------------------------|------------------------------
[Brain Board](/docs/kit/brain_board)    | 5V, using the provided cable
[Power Board](/docs/kit/power_board)    | 12V, via the yellow XT60 to the [battery](/docs/kit/batteries)
[Motor Board](/docs/kit/motor_board)    | 12V
[Ruggeduino](/docs/kit/ruggeduino)      | via USB
[Servo Board](/docs/kit/servo_board)    | 12V

In order to connect the Motor and Servo Boards to the Power Board,
 you will need to create a power cables.
This should be done using the provided _power wire_ (this is the thicker wire provided in the kit)
 and a pair of green CamCon connectors.

When creating your power cables be sure to refer to the pages for each board
 so that you connect the wires the right way around.
In our diagrams, the <span class="positive-connector">+</span> outputs from the
 the Power Board should be connected to the <span class="positive-connector">+</span>
 inputs on the board being powered.


Video
-----

The following video contains an overview which covers the [brain board](/docs/kit/brain_board),
[power board](/docs/kit/power_board) and a [motor board](/docs/kit/motor_board).

<iframe class="video center"
        height="315"
        width="560"
        src="https://www.youtube-nocookie.com/embed/vhZjjCdhVE0?rel=0"
        frameborder="0"
        allowfullscreen>
</iframe>
