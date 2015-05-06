---
description: Explains how to use the Student Robotics robot API to control motors.
layout: docs
title: Motors
---
The `motors` object is used to control a collection of motors.
Similar to `ruggeduinos` and `servos`, `motors` can be used like a list.
To do something with the **first motor** board, you would use:

{% highlight python %}
R.motors[0].something...
{% endhighlight %}

...because indexes are 0-based (counting starts from 0, not 1).

When you have more than one motor board connected to your kit they will be ordered based upon their SR Part Code, as written on the underside of the board.

The SR Part Code of each detected motor board is also printed to the log when your robot starts.
It will look something like this:

<pre class="not-code">
Found the following devices:
 - Motors:
    0: Motor( serialnum = "SR0XJ1F" )
    1: Motor( serialnum = "SR0A123" )
</pre>


However, like `ruggeduinos`, `motors` is actually a dictionary.
As a result, in `motors` you can also use the SR Part Code of the motor board as a key.
For example, if you had a board that was labelled "SR0A123",
you could do this instead:

{% highlight python %}
R.motors["SR0A123"].something...
{% endhighlight %}

Setting motor power
-------------------

Motor power is controlled using [PWM](http://en.wikipedia.org/wiki/Pulse-width_modulation) with 100% power being a [duty cycle](http://en.wikipedia.org/wiki/Duty_cycle) of 1. You set the power with an integer value between -100 and 100 inclusive (where a negative value puts the motor in reverse). The field to change the output power is `power`. As each motor board has two outputs you will need to specify which output you want to control:

{% highlight python %}
from sr.robot import *
import time

R = Robot()

# motor 0, channel 0 to full power forward
R.motors[0].m0.power = 100

# motor 1, channel 0 to full power reverse
R.motors[1].m0.power = -100

# motor 0, channel 1 to half power forward
R.motors[0].m1.power = 50

# motor 1, channel 0 stopped
R.motors[1].m0.power = 0

# the following will put motor 0, channel 1 at 25% power (forwards) for 2.5 seconds:
R.motors[0].m1.power = 25
time.sleep(2.5)       # wait for 2.5 seconds
R.motors[0].m1.power = 0
{% endhighlight %}

You can read the current power value for a motor using the same field:

{% highlight python %}
# get the current output power of motor 0, channel 0
currentTarget = R.motors[0].m0.power
{% endhighlight %}

Stopping the motors
-------------------

When you set the motor power to 0, this signals the motor board to actively stop that motor from turning.

{% highlight python %}
# store the motor in a local variable because typing it out gets really boring
molly = R.motors[0].m0

# set the power to 100 for a second, then stop immediately
molly.power = 100
time.sleep(1)
molly.power = 0
{% endhighlight %}

However, you may also want to allow the motors to gently coast to a halt.
This can be achieved by setting the `use_brake` field of the individual motor.

{% highlight python %}
# set braking mode
molly.use_brake = False

# set the power to 100 for a second, then coast to a stop
molly.power = 100
time.sleep(1)
molly.power = 0

# Print the current braking mode (might be handy for debugging!)
print("m0.use_brake = {0}".format(molly.use_brake))
{% endhighlight %}

The `use_brake` value defaults to `True` and, just like the `power` value,
will remain set until you change it.
