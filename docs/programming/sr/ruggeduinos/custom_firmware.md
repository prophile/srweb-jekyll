---
description: Explains how to use the Student Robotics robot API to interact with a
  Ruggeduino with customised firmware.
layout: docs
title: Ruggeduino custom firmware
---
The Ruggeduino that came as part of your kit was shipped with a firmware that provides the functionality outlined in the [Ruggeduino](/docs/programming/sr/ruggeduinos) page.
You may wish to extend the functionality of this firmware, or completely replace it.
The `sr.robot` library provides support for three Ruggeduino firmware scenarios:

 1. Default SR firmware
 2. [Extended SR firmware](#extension): Firmwares that add commands to the default SR firmware.
 3. [Completely custom](#completely): Any firmware not derived from the SR firmware.

By default, the [`sr.robot`](/docs/programming/sr/) library assumes that all connected Ruggeduinos are running the SR firmware.
If you wish to use an extended SR firmware, or completely custom firmware,
 then you need to tell the `Robot` object what to do with your Ruggeduino(s).
To do this, you will need to expand the initialisation of your `Robot` object as detailed [here](/docs/programming/sr/#CustomRobotInit).
Your code will then look something like this:

{% highlight python %}
from sr.robot import *

R = Robot.setup()

R.init()

R.wait_start()

# The rest of your code
{% endhighlight %}

The next step depends on whether you are running an extended SR firmware, or a completely custom firmware.

[Extension of the SR firmware](#extension) {#extension}
------------------------------

You may wish to extend the SR firmware with additional functionality.
This will allow you to continue using the commands already provided by the SR firmware (e.g. `digital_read()`),
 which means any existing robot code you have won't need modifying very much.
When you extend the SR firmware, you'll be adding at least one new command to the firmware.
There are almost limitless possibilities of what your commands may do, but here are some examples to give you an idea:

 * Talk to an SPI or I2C sensor.
 * Read N input pins at the same instant in time.
 * Time pulses received from an ultrasound sensor.

There are three steps that you will need to go through to implement and use your custom commands:

### Step 1: Add your command to the Ruggeduino firmware

To extend the SR firmware, you will need to first download its [source code](/resources/kit/ruggeduino-fw.ino), and edit it in the Arduino IDE.
When the SR ruggeduino python library wants the ruggeduino to run a command, it sends it a single character to tell it which command to run.
You'll find a `switch` statement in the `loop()` function that processes this command character:

{% highlight cpp %}
switch (selected_command) {
      case 'a':
        command_analogue_read();
        break;
      case 'r':
        command_read();
        break;
      case 'l':
        command_write(LOW);
        break;

 // ... and so on ...
{% endhighlight %}

For example, you can see in the above that when it receives an "a" character, it calls the `command_analogue_read()` function.
This function does pretty much what it says on the tin: it reads an analogue pin.

You will need to add your own entry into this `switch` statement for your new command.
This will need to be represented by a character that doesn't already appear in the switch statement.
Let's say you chose "c"; your entry would look like this:

{% highlight cpp %}
switch (selected_command) {
      case 'c':
        command_bake_cake();
        break;

 // ... all the original entries ...
{% endhighlight %}

You would then write your `command_bake_cake()` function.
Your command can read additional data from the serial port if it requires additional information to operate.
It can also write a response back to the host (your Python code).
Have a look at the `command_read()` function to see how to do this.

### Step 2: Extend the `Ruggeduino` class

Your robot's python code will, by default, use a `Ruggeduino` object to communicate with the Ruggeduino.
The object returned to you when you type `R.ruggeduinos[0]` is a `Ruggeduino` instance.
This object knows how to talk to the default command handlers in the SR firmware.

<div class="info" markdown="1">
Don't worry if you don't know what "object" means -- you can probably blag this without knowing!
If you do want to know about them, you'll find introductions to them all over the web.
You could try [this one](http://www.jesshamrick.com/2011/05/18/an-introduction-to-classes-and-inheritance-in-python/), for example.
</div>

You'll need to extend the `Ruggeduino` class, giving it at least one extra method to perform your command.
Start by adding this to your code:

{% highlight python %}
from sr.robot import *

class CustomisedRuggeduino(Ruggeduino):
    pass
{% endhighlight %}

You've just declared a class called `CustomisedRuggeduino` (you will probably want to call it something else that makes more sense in your application).
At the moment, it behaves in exactly the same way as the `Ruggeduino` class.
You now need to add your custom method to it:

{% highlight python %}
from sr.robot import *

class CustomisedRuggeduino(Ruggeduino):

    # Your function for instructing a Ruggeduino to bake a cake
    def bake_cake(self):
        with self.lock:
            self.command("c")
{% endhighlight %}

Skipping ahead for a moment: Once we've told your `Robot` object about this `CustomisedRuggeduino`
 class (which we do in the next step), you will be able to do this:

{% highlight python %}
R.ruggeduinos[0].bake_cake()
# and you'll still be able to do this:
R.ruggeduinos[0].digital_read(3)
{% endhighlight %}

<div class="warning" markdown="1">
The IDE will unfortunately error about the lack of a `bake_cake` method (or your equivalent) in the above code.
This is an expected restriction of the way the IDE checks the syntax of your code.

You can therefore ignore these errors (though you should be careful that the error is one of these and not something else).
</div>

#### `with self.lock:`

You'll notice that the code above contains a line that reads:

{% highlight python %}
with self.lock:
{% endhighlight %}

Whenever you call `self.command`, you need to ensure that it is called within a block of code headed by this `with` statement.
This is a tool that makes your code "thread-safe".
If you're not using threads, then you will still need to use it, but it won't affect the behaviour of your program.

#### Responses

The response from your command is returned by the `self.command` function.
Remember that it will be a string, so you will need to convert it as necessary.

If, for example, our cake-baking function on our Ruggeduino responds with the number of cakes that were baked, then we could do this:

{% highlight python %}
class CustomisedRuggeduino(Ruggeduino):

    def bake_cake(self):
        with self.lock:
            resp = self.command("c")
        return int(resp)
{% endhighlight %}


### Step 3: Tell the `Robot` to use your extended class

Now that you've extended the `Ruggeduino` class to create your `CustomisedRuggeduino` class,
 it's time to tell the `Robot` object about it using the `ruggeduino_set_handler_by_fwver` function:

{% highlight python %}
from sr.robot import *

# The class that you wrote in step 2
class CustomisedRuggeduino(Ruggeduino):
    def bake_cake(self):
        with self.lock:
            self.command("c")

R = Robot.setup()

# Register the custom class with the Robot object
R.ruggeduino_set_handler_by_fwver("SRcustom", CustomisedRuggeduino)

R.init()

R.wait_start()

# Now you can call your custom function!
R.ruggeduinos[0].bake_cake()
{% endhighlight %}

You're done!  You can now use your custom cake-baking firmware!


#### Multiple Ruggeduinos with Extended SR Firmwares

You may wish to use multiple Ruggeduinos with your robot, each supporting a different set of commands.
There are two ways to go about this.

You can change the string "SRCustom" in your firmwares to be something different
 (but make sure you keep the colon that follows it!),
 and then change the string you pass to `ruggeduino_set_handler_by_fwver` to suit.
For example, if you change it to be "CakeBaker" in one of your ruggeduinos,
 but leave it as "SRCustom" in the other, then your enumeration code would become:

{% highlight python %}
R.ruggeduino_set_handler_by_fwver("SRcustom", CustomisedRuggeduino)
R.ruggeduino_set_handler_by_fwver("CakeBaker", CakeBakerRuggeduino)
{% endhighlight %}

Alternatively, you can set the handling class using the ID of the Ruggeduino.
The Ruggeduino IDs are written to the robot log when you run a program on your robot with your Ruggeduino connected.
Instead of using `ruggeduino_set_handler_by_fwver`, you use `ruggeduino_set_handler_by_id`:

{% highlight python %}
R.ruggeduino_set_handler_by_id("752303138333517171B1", CustomisedRuggeduino)
R.ruggeduino_set_handler_by_id("10231028301928310283", CakeBakerRuggeduino)
{% endhighlight %}

You will then be able to access your ruggeduino using its ID like so:

{% highlight python %}
R.ruggeduinos["752303138333517171B1"]
{% endhighlight %}


[Completely custom firmware](#completely) {#completely}
----------------------------

When configured correctly, the `Robot` object will perform absolutely no serial communications with a completely custom firmware.
We refer to this as *ignoring* a Ruggeduino.
To configure a `Robot` object to ignore a Ruggeduino with custom firmware, you will need to provide it with the Ruggeduino's ID.

The Ruggeduino ID is a 20 character string of mostly numbers, and is output in the robot log when you run a program on your robot with your
Ruggeduino connected.

After calling `Robot.setup()`, you should call the `ruggeduino_ignore_id`
 method of the robot object, with the ID as an argument.
You'll need the ID later, so it's best to save it into a variable:

{% highlight python %}
from sr.robot import *

RUGGEDUINO_ID = "752303138333517171B1" # Replace this with the actual ID

R = Robot.setup()

R.ruggeduino_ignore_id( RUGGEDUINO_ID )

R.init()

R.wait_start()

# The rest of your code
{% endhighlight %}

If you need to communicate with the Ruggeduino firmware, you will need its serial device path.
This is accessible after the `R.init()` call through the list of Ruggeduinos:

{% highlight python %}
# ... Robot.setup() ... etc.

R.init()

ruggeduino_device = R.ruggeduinos[RUGGEDUINO_ID].path

# Do your Ruggeduino initialisation here if you wish

R.wait_start()

# The rest of your code
{% endhighlight %}

You may wish to use pyserial to communicate with the Ruggeduino, in which case you could open it like so:

{% highlight python %}
import serial
from sr.robot import *

RUGGEDUINO_ID = "752303138333517171B1"

R = Robot.setup()
R.ruggeduino_ignore_id( RUGGEDUINO_ID )
R.init()
R.wait_start()

ser = serial.Serial( R.ruggeduinos[RUGGEDUINO_ID].path )

{% endhighlight %}

Refer to the [pyserial documentation](http://pyserial.sourceforge.net/) for more information on how to use pyserial.

