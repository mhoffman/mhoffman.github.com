---
layout: default
title: mhoffman.github.com/papers/
---

# Papers

{% for paper in site.data.publications %}
1. **{{ paper.title}}**

   {{ paper.authors }} {{ paper.journal }} ({{ paper.date}}) {% if paper.doi %} <a href='http://dx.doi.org/{{ paper.doi }}'>DOI</a> | {% endif %} {% if paper.arxiv %} <a href="http://arxiv.org/abs/{{paper.arxiv}}">ArXiV</a> {% endif %}
{% endfor %}
