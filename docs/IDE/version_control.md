---
description: An explanation of how to best use the versioning that the IDE does.
layout: docs
title: Version Control in the IDE
---
===============

Each project within the IDE is stored within a [git][wikipedia-git] repository.
This means that whenever you save a change to a file,
instead of just overwriting its contents the IDE saves the new content of the file
(plus the [message](/docs/IDE/good_commit_messages) used to describe it)
as a new _version_.

Thankfully, instead of adding an ever-increasing number to the end of the file-name,
this is done in a manner that stores all the "old" versions out of the way,
leaving your "working copy" with just the version that you want to see (usually the latest).

The collection of changes made to a file or project are known as its _history_.

[Seeing a list of changes to a file](#FileLog) {#FileLog}
----------------------------------

If you want to see a list of changes made to a file,
select the file in the file list (hold Ctrl and click the file name)
and then click the "View log" link on the left.
This will open the log page for the selected file:

![An image of the log for a single file](/images/content/ide/file-log.png
 "The log view shows the messages given to describe the changes to a file,
  as well as links to view the file at a historic version, or to see the changes a version made.")

From here, you can choose to view the whole file at particular point in the history,
see the actual line changes that a particular commit made,
or even revert the content of the file to a previous state.

[Undoing changes to a file](#RevertingChanges) {#RevertingChanges}
-------------------------

If you need to "undo" a set of changes to a file, perhaps because they break something,
then this can be done from the [log page](#FileLog) for the file.
You simply need to select the revision that you want to go back to,
and click the "Revert To" button.

This will undo all the changes since the selected revision, and store the
resulting change as a new version.
Note that as a result, you will still be able to see the "undone" versions
in the history, but the changes they introduced will no longer be present in the file.

[Seeing an old version of a project](#ProjectHistory) {#ProjectHistory}
----------------------------------

If you want to see the contents of a project at a given time in the past,
open the project and then use the calender in the bottom left of the projects page:

![An image of the projects page calender,
  with the revision selector closed](/images/content/ide/projpage-calender-closed.png
 "The calender on the projects page, before a date has been selected.")

The dates with blue backgrounds are days on which changes were made,
and the date in bold is the current date.

![An image of the projects page calender,
  with a date selected and the revision selector open](/images/content/ide/projpage-calender-open.png
 "Choosing a version from the calender on the projects page, after a date has been selected.")

Clicking on a day that has changes will cause the versions for that day to be shown in the drop-down box.
The details include the revision id (the letters and numbers on the left),
the person that made the change, the message they gave and the time the change was made.

Choosing a version from the drop-down will cause the project page to show the project as it was immediately following the selected change,
and if you open any files at this point, their content will also be that for the chosen revision.

To get back to seeing the "current" version, simply select the "HEAD" option in the drop-down.
The projects page will then continue to show the current state of the project
