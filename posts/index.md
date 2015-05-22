---
layout: default
title: posts
---

# Random Stuff I Wrote

---

{% for post in site.posts %}
{{ post.date | date_to_string }}

{{ post.content }}
---
{% endfor %}
