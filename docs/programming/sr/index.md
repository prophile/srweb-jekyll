---
description: An introduction to the module provided by us
layout: docs
title: SR Module
---
Student Robotics has written a module &mdash; `sr.robot`  &mdash; which is used to interface with the hardware.
It handles all the low-level interactions so you don't have to.
To set the output power of output 0 of the first motor board to -30%, for example, you would simply write:

{% highlight python %}
R.motors[0].m0.power = -30
{% endhighlight %}

`-30` would be backwards (depending upon which way you wired up the motor) &mdash; 30% power in reverse.

To gain access to all of this functionality, all you need to do is write:

{% highlight python %}
from sr.robot import *
{% endhighlight %}

...at the top of your code (before you use any of its functionality, basically).
This imports the Student Robotics module that we've written to interface with our hardware.

Then, within the `sr.robot` module, there is a `Robot` class that should be instantiated, as follows:

{% highlight python %}
from sr.robot import *
R = Robot()
{% endhighlight %}

Within your `Robot` (`R` in this case), you then have access to the following attributes:

* [motors](/docs/programming/sr/motors/)
* [power](/docs/programming/sr/power/)
* [servos](/docs/programming/sr/servos/)
* [ruggeduinos](/docs/programming/sr/ruggeduinos/)
* [vision](/docs/programming/sr/vision/)

They can be used in your code just like the example above.
Note that `motors`, `ruggeduinos`, and `servos` are Python lists, and so should be accessed as such.
Here are some examples:

{% highlight python %}
R.motors[0].m0.power = 50   # WILL work, if motor 0 exists
R.motors[1].m0.power = -20  # WILL work, if motor 1 exists
R.motors.m0.power = 42      # WON'T WORK

# the above is similar to the situation for 'ruggeduinos' and 'servos'
{% endhighlight %}

A number of examples in the documentation will assume you've instantiated the required `Robot` class and have called it `R`.
From here in, if you see a `R.something`, the requirement of the `sr.robot` import line and the instantiation of `Robot` as `R` is implicit.

[Other Robot Attributes](#OtherRobotAttributes) {#OtherRobotAttributes}
----------------------

As well as the attributes listed above, the Robot class also has the following attributes, which you may find useful:

zone
:    The number of the zone that the robot is associated with.  An integer from 0 to 3 inclusive.

mode
:    Either "comp" or "dev".  When in a competition match, this will be "comp", and at all other times this will be "dev".

usbkey
:   The path to the USB memory stick.
    Your code is unzipped and run from a temporary directory, therefore files you create will be lost when the kit is turned off.
    You can use this to easily read from and write to files on the stick itself.
    Note that the USB memory stick is mounted synchronously, so any writes to it will block until complete and may slow down your code.

    An example of how the `usbkey` attribute might be used:

    ~~~~~ .python
    from sr.robot import *
    import os

    R = Robot()
    print "The path to the USB key is:", R.usbkey
    print "My file on the USB contains:"
    f = open(os.path.join(R.usbkey, "my-file.txt"), "r")
    print f.read()
    f.close()
    ~~~~~

[Custom Robot Object Initialisation](#CustomRobotInit) {#CustomRobotInit}
----------------------

Normally the Robot object is initialised with the following:

{% highlight python %}
R = Robot()
{% endhighlight %}

However if you want to:

 * customise your Ruggeduino firmware
 * initialise some hardware or software before the start button is pressed

Then Robot initialisation can be broken up as follows (this example is equivalent to the previous code excerpt):

{% highlight python %}
R = Robot.setup()

# Setup phase.
# Here you can configure hardware enumeration

R.init()

# Initialisation phase.
# Here you can perform hardware/software initialisation before start

R.wait_start()
{% endhighlight %}

During the setup phase, the Robot hardware is inaccessible.
For example,`R.motors` is unavailable since enumerations occurs in the `init` function.
In this phase you can configure how the Robot finds and configures hardware.

After the `init` call, all hardware is accessible.
If you have any hardware which must be initialised before the start button is pressed,
 the initialisation phase is the time to do so.
