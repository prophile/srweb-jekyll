---
layout: docs
title: Power
---
There are a few things that can be done with the power board, namely current and voltage sensing.
As there is only one power board, it is not accessed like a list like `motors` for example:

{% highlight python %}
R.power.something...
{% endhighlight %}

[Battery Status](#battery) {#battery}
-------

The power board can report both the battery voltage, in Volts, and the current being drawn from it, in Amps.
You can access these values like so:

{% highlight python %}
# Print the battery voltage and current to the log
print R.power.battery.voltage, R.power.battery.current
{% endhighlight %}

A fully charged battery will measure 12.6V.
The power board will turn off and signal a low battery at 10.2V.
The discharge curve is roughly linear between 11.4V and 10.4V.
