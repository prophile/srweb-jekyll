---
layout: docs
title: Code Checking
---
Your code is checked automatically every time you click _Export Project_ in the _Projects_ tab.
If you wish to check code before you export it, you can do so by clicking the _Check Code_ button also on the _Projects_ tab.
If there are any errors with your code, the code checker will present a warning offering you the chance to view the errors.

The errors checking is done by running your code past a number of checkers,
 including [pylint](http://www.logilab.org/project/pylint).
The check will check all your imported modules,
 so if you've written your code across multiple files (and imported them appropriately)
 you only need to run the check against robot.py &ndash; the checking will find all the used files and check them too.

On the errors page, you will see a listing of all the files that have been checked and found to have errors in them.
You can click on the name of each file to view it,
 or you can double-click on a particular error to be taken to the error's location in the source.

The formatting of the errors is as follows:

<pre class="not-code">
line: [severity] message
</pre>

So an error on the second line of a file,
 where you've used a variable without declaring it,
 such as:

{% highlight python %}
import sr.robot
print bacon
{% endhighlight %}

Would show up as:
<pre class="not-code">
2: [E] Undefined variable 'bacon'
</pre>
