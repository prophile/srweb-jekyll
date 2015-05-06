---
description: Describes the Student Robotics robot simulator
layout: docs
title: Simulator
---
The SR robot simulator allows you to try out programming ideas with a virtual robot in a virtual arena.
The virtual robot has a simple grabber and two motors (configured for skid steering).
Its programming interface is very similar to that for your real robot (see the [Interface section](#Interface)).

Installation
------------

Follow the instructions for your platform:

* [Windows](#Windows)
* [Linux](#Linux)
* [Mac OS X](#MacOSX)

### [Windows](#Windows) {#Windows}

First, download [the Windows ZIP][windows-zip] and extract it.
In the ZIP you will find a directory called `Portable Python`, which contains `PyScripter-Portable.exe`. Double click this to open the PyScripter development environment.

Open the file named `run.py` in the `robot-sim` folder. This program allows you to launch the simulator.
To try it out, run it (by clicking the green play icon on the toolbar, or pressing Ctrl+F9).
A dialog box will ask you for a program name. Enter `test.py` and press ENTER.
A test program will run in a simulated arena.
(You may need to bring the simulator window to the front by clicking on it in your taskbar.)

To create your own program, click File > New. The new file should contain the
code you need to get started. Write your code as normal. Save the file in the
`robot-sim` folder on your Desktop.

To run your program, run `run.py`, like you did before. Enter the name of your
code file (including the `.py`) into the dialog box and press ENTER.

### [Linux](#Linux) {#Linux}

First, download [the Linux ZIP][linux-zip] and extract it.

The simulator requires three libraries: [pygame][], [PyPyBox2D][], and [PyYAML][].
The easiest way to install these is through your distribution's package manager (although PyPyBox2D is only available through `pip`).
For example, on Ubuntu, you might run the following commands (the Python development tools are required for `pip` to install PyPyBox2D):

{% highlight bash %}
$ sudo apt-get install python-dev python-pip python-pygame python-yaml
$ sudo pip install pypybox2d
{% endhighlight %}

To run a test program, open a terminal in the `robot-sim` directory from the ZIP and run:

{% highlight bash %}
$ python run.py test.py
{% endhighlight %}

To create your own program, write it in a text file using your favourite editor and save it in the `robot-sim` directory. Run it by replacing `test.py` in the previous command with the file name.

### [Mac OS X](#MacOSX) {#MacOSX}

First, download [the Mac OS X ZIP][macosx-zip] and extract it. All files referred to here are in the `robot-sim` folder from that ZIP.

To install the prerequisites for the simulator, run `install-macosx.command`.

To run a program in the simulator, run `run-macosx.command`, and enter the names of the files you wish to run, separated by commas.
To test it out, enter `test.py` and press ENTER. A test program will run in a simulated arena.

To create your own program, enter it into a text file and save it in
`robot-sim`. Write your code as normal, and run in the same way.

[Interface](#Interface) {#Interface}
-----------

Unless otherwise stated, the simulator's API is the same as the real SR API described in the docs.

### Motors

Motor boards cannot be addressed by serial number.

### Servos

Servos are not supported in the simulator.

### The Grabber

Instead of servos, the robot is equipped with a grabber, capable of picking up a token which is in front of the robot and within 0.4 metres of the robot's centre. To pick up a token, call the `R.grab` method:

{% highlight python %}
success = R.grab()
{% endhighlight %}

The `R.grab` method returns `True` if a token was successfully picked up, or `False` otherwise. If the robot is already holding a token, it will throw an `AlreadyHoldingSomethingException`.

To drop the token, call the `R.release` method.

### Vision

To help the robot find tokens and navigate, each token has markers stuck to it, as does each wall. The `R.see` method returns a list of all the markers the robot can see, as `Marker` objects. The robot can only see markers which it is facing towards.

Each `Marker` object has the following attributes:

info
:   a `MarkerInfo` object describing the marker itself. Has the following attributes:

    code
    :   the numeric code of the marker.

    marker_type
    :   the type of object the marker is attached to (either `MARKER_TOKEN` or `MARKER_ARENA`).

        <div class="warning" markdown="1">
        Note that the marker type for the 2015 flags is `MARKER_TOKEN`, not `MARKER_FLAG` as it is in [the real SR API](/docs/programming/sr/vision/#MarkerInfo).
        </div>

    offset
    :   offset of the numeric code of the marker from the lowest numbered marker of its type. For example, token number 3 has the code 43, but offset 3.

    size
    :   the size that the marker would be in the real game (in metres), for compatibility with the SR API.

centre
:   the location of the marker in polar coordinates, as a `PolarCoord` object. Has the following attributes:

    length
    :   the distance from the centre of the robot to the object (in metres).

    rot_y
    :   rotation about the Y axis in degrees.

dist
:   an alias for `centre.length`

res
:   the value of the `res` parameter of `R.see`, for compatibility with the SR API.

rot_y
:   an alias for `centre.rot_y`

timestamp
:   the time at which the marker was seen (when `R.see` was called).

For example, the following code lists all of the markers the robot can see:

{% highlight python %}
markers = R.see()
print "I can see", len(markers), "markers:"

for m in markers:
    if m.info.marker_type == MARKER_TOKEN:
        print " - Token {0} is {1} metres away".format(m.info.offset, m.dist)
    elif m.info.marker_type == MARKER_ARENA:
        print " - Arena marker {0} is {1} metres away".format(m.info.offset, m.dist)
{% endhighlight %}

[windows-zip]: /resources/simulator/simulator-windows.zip
[linux-zip]: /resources/simulator/simulator-linux.zip
[macosx-zip]: /resources/simulator/simulator-macosx.zip
[pygame]: http://pygame.org/
[pypybox2d]: https://pypi.python.org/pypi/pypybox2d/2.1-r331
[pyyaml]: https://pypi.python.org/pypi/PyYAML/
[pip]: https://pip.pypa.io/en/latest/
