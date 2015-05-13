---
layout: main
title: Events
---

Events
======

Student robotics runs several events throughout the competition year.
The competition begins at a [kickstart](/events/kickstart) event,
teams then can attend several [tech days](/events/tech_days) to work on their robots.
Finally, the year finishes with the [competition](/events/competition).

For a list of the events happening this year, see the [key dates](/key_dates) page.

Archive
-------

<table>
  <tr>
    <th>Title</th>
    <th>Kind</th>
    <th>Date</th>
    <th>Branch</th>
  </tr>

  {% for event in site.events reversed %}
    <tr>
      <td><a href="{{ event.url }}">{{ event.title }}</a></td>
      <td><a href="{{ event.url }}">{% event_type event human %}</a></td>
      <td><a href="{{ event.url }}">{% event_date event human %}</a></td>
      <td><a href="{{ event.url }}">{{ event.branch }}</a></td>
    </tr>
  {% endfor %}
</table>
