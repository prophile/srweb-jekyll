---
description: Help with common problems encountered when using the SR kit
layout: docs
title: Troubleshooting
---
If you are experiencing problems with either the Student Robotics hardware,
IDE or python library you should check here first to see if there is a simple solution.
If you don't find the information you need in this section you can use the
[forum](/forum/) to get help with your specific problem.

1. [`sr.robot` python library issues](/docs/troubleshooting/python) &mdash; Common problems with the `sr.robot` python library and possible solutions.
2. [Interactive Troubleshooter](/docs/troubleshooting/interactive_troubleshooter) &mdash; Consider using the Interactive Troubleshooter to narrow down your problem and find a solution.

[General Troubleshooting Tips](#GeneralTips) {#GeneralTips}
----------------------------

Simplify the task
:   By reducing the complexity of whatever you're trying to do, the chances
    that you've overlooked something are smaller. It also allows you to rule
    out a collection of things which could be causing the issue and makes
    the system easier to understand.

    In turn, that means that if you do need to get help from someone else
    you don't need to spend a long time explaining what's going on.

Explain it to someone else
:   By explaining the system to someone else, even (and for some reason
    _especially_) an [inanimate object](https://en.wikipedia.org/wiki/Rubber_duck_debugging),
    you're forced to think about each piece of the system and describe
    what it does and how it works.

    This often leads you to realise which part of the system isn't working,
    without any actual input from the other person.

Check the log file for errors
:   If your program has an error in it, it will stop running or not run at all.
    Check [the log file](/docs/troubleshooting/python#ReadingTheLogs) on your
    [tablet](/docs/kit/tablet) or USB stick to see any error reports.

Print all the things
:   Adding [`print` statements](/docs/python/tutorial/inputoutput.html)
    into the code you're working on allows you to track the progress of
    the system while it is running. When working on non-software systems
    other mechanisms are used to achieve the same goal &mdash; LEDs
    commonly used for this in electronics hardware, and this is part
    of the reason our boards are covered in them.

    On the robots the output from any `print` statements will end up
    in [the log file](/docs/troubleshooting/python#ReadingTheLogs) on the
    [tablets](/docs/kit/tablet) and USB stick.

Check the docs
:   It's very easy to end up thinking that you know how something works
    and then forget something out of familiarity.

    By double-checking the appropriate docs (be it for the [kit](/docs/kit),
    for [Python](/docs/python) or for the extra thing you've bought) you
    can be completely sure that you've not missed something.
