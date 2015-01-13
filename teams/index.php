---
layout: main
---
<h1>Team Status</h1>
<ul>
{% for team in site.data.teams %}
  <li>{{ team[0] }}: <a href="{{ team[1].URL }}">{{ team[1].name }}</a></li>
{% endfor %}
</ul>

