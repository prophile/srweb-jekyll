---
description: Explains how to use the Student Robotics robot API to interact with ruggeduinos.
layout: docs
title: IO (Ruggeduino)
---
The [Ruggeduino](http://ruggedcircuits.com/html/ruggeduino.html)
provides a total of 18 pins for either digital input or output (labelled 2 to 13 and A0 to A5),
including 6 for analogue input (labelled A0 to A5).

The `ruggeduinos` object is used to control a collection of Ruggeduinos.
Similar to `motors` and `servos`, `ruggeduinos` can be used like a list.
To do something with the **first Ruggeduino** board, you would use:

{% highlight python %}
R.ruggeduinos[0].something...
{% endhighlight %}

...because indexes are 0-based (counting starts from 0, not 1).

When you have more than one Ruggeduino board connected to your kit
they will be ordered based upon their serial number.

The serial number of each detected Ruggeduino is printed to the log when your robot starts.
It will look something like this:

<pre class="not-code">
Found the following devices:
 - Ruggeduinos:
    0: Ruggeduino( serialnum = "752303138333517171B1" )
</pre>

In addition, like `motors`, `ruggeduinos` is actually a dictionary.
As a result, in `ruggeduinos` you can also use the Ruggeduino serial number as a key.
For example, if you had a board whose serial number was "752303138333517171B1",
you could do this instead:

{% highlight python %}
R.ruggeduinos["752303138333517171B1"].something...
{% endhighlight %}

[Setting pin modes](#pinmodes) {#pinmodes}
--------------------------------------------------------------------------

To use one of the pins on the Ruggeduino, you must first set whether you want it to behave as an input or as an output.
You can do this with the following code:

{% highlight python %}
R.ruggeduinos[RUGGEDUINO_BOARD_NUMBER].pin_mode(PIN_NO, MODE)
{% endhighlight %}

The possible values for `MODE` are:

`INPUT`
:   set the pin to [input mode](#input)

`OUTPUT`
:   set the pin to [output mode](#output)

`INPUT_PULLUP`
:   set the pin to input mode with a [pull-up resistor](#pullup)

An example of how to use this is below:

{% highlight python %}
# set Ruggeduino board 0's pin 2 to output
R.ruggeduinos[0].pin_mode(2, OUTPUT)
# set Ruggeduino board 0's pin 3 to input
R.ruggeduinos[0].pin_mode(3, INPUT)
# set Ruggeduino board 0's pin 4 to input and enable pull-up resistor
R.ruggeduinos[0].pin_mode(4, INPUT_PULLUP)
{% endhighlight %}

<div class="warning">You cannot use pins 0 and 1, as using these would disrupt communications between the Ruggeduino and the Power Board.</div>

[Input](#input) {#input}
-------

You can read a **digital** input pin with the following code:

{% highlight python %}
# R.ruggeduinos[RUGGEDUINO_BOARD_NUMBER].digital_read(PIN_NO)

# to read Ruggeduino board 0's digital pin 3...
pin0 = R.ruggeduinos[0].digital_read(3)
{% endhighlight %}

`pin0` will now contain `True` or `False` depending on whether the pin was high (3.3v) or low (0v), respectively.

You can read an **analogue** input pin with the following code:

{% highlight python %}
# R.ruggeduinos[RUGGEDUINO_BOARD_NUMBER].analogue_read(PIN_NO)

# to read Ruggeduino board 0's analogue pin A0...
pin0 = R.ruggeduinos[0].analogue_read(0)
{% endhighlight %}


[Output](#output) {#output}
--------

You can only set digital outputs (there's no analogue output, although you may feel free to modify the Ruggeduino's firmware to add the ability to output [PWM](https://wikipedia.org/wiki/Pulse-width_modulation "Pulse-width modulation") if you desire). To set a digital output pin, you would use the following:

{% highlight python %}
# R.ruggeduinos[RUGGEDUINO_BOARD_NUMBER].digital_write(PIN_NO, VALUE)

# to set Ruggeduino board 0's pin 2 high:
R.ruggeduinos[0].digital_write(2, True)

# to set Ruggeduino board 0's pin 2 low:
R.ruggeduinos[0].digital_write(2, False)
{% endhighlight %}

[Pull-up resistors](#pullup) {#pullup}
----------------------------------------------------------------------

The Ruggeduino possesses the ability to enable a built-in pull-up resistor on any input pin.
This takes a small amount of explanation.

Normally, input pins are not connected to anything - known as "floating".
In this state, they might read high or low, or different values depending on their environment.
This is obviously not good for consistent control.

Many pieces of off-the-shelf electronics that have some form of standard I/O output will connect this pin to 3.3V (high) and 0V (low) when required,
 so this is not a problem. However, for simple electronics, a microswitch for example,
 you would normally be required to connect a resistor between the input pin and 3.3V (a pull-up resistor),
 or between the input pin and 0V (a pull-down resistor) to keep the input in a known state until the switch overrides it by connecting directly to the opposite state.

However, the built-in pull-up resistor alleviates this need.
It essentially wires in a resistor connected to 3.3V, meaning that when this option is enabled, an input pin will "default" to being high.
This means you can simply connect a switch between the input pin and a ground pin without any need of resistors - when the switch is open, the pin will read high; when closed, it will read low.
