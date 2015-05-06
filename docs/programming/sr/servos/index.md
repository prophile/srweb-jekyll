---
layout: docs
title: Servos
---
A servo board can have a number of servos plugged into it, with their positions controlled using the `servos` object.
As with `ruggeduinos` and `motors`, `servos` is a list, with indexes based on the order of their SR part codes, printed on a sticker on the bottom of the case.
The position of servos can range from `-100` to `100` inclusive:

{% highlight python %}
# R.servos[N][SERVO_NUMBER] = POS

# set servo 1's position (on the first servo board connected, board 0) to 20
R.servos[0][1] = 20
# Set servo 2's position (on the servo board with part code SRABC) to -55
R.servos["SRABC"][2] = -55
{% endhighlight %}

<div class="warning" markdown="1">
It is important that you use integers (whole numbers, such as `10` instead of
`10.0`) when specifying servo positions.
</div>

You can get a servo's currently set position in a similar way:

{% highlight python %}
# variable = R.servos[N][SERVO_NUMBER]

# store the position of servo board 0's servo 0 in 'bees'
bees = R.servos[0][0]
{% endhighlight %}

[How the set position relates to the servo angle](#ServoAngle) {#ServoAngle}
-----------------------------------------------

<div class="warning">
You should be careful about forcing a servo to drive past its end stops.
Some servos are very strong and it could damage the internal gears.
</div>

The angle of an RC servo is controlled by the width of a pulse supplied to it periodically.
There is no standard for the width of this pulse and there are differences between manufacturers as to what angle the servo will turn to for a given pulse width.
To be able to handle the widest range of all servos our hardware outputs a very wide range of pulse widths which in some cases will force the servo to try and turn past its internal end-stops.
You should experiment and find what the actual limit of your servos are (it almost certainly won't be -100 and 100) and not drive them past that.
