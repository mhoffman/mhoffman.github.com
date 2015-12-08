---
layout: default
title: mhoffman.github.com/papers/
---

# Papers

{% for paper in site.data.publications %}
1. **{{ paper.title}}**
   {{ paper.authors }}
   {{ paper.journal }} ({{ paper.date}}) <a href='http://dx.doi.org/{{ paper.doi }}'>DOI</a> | <a href="http://arxiv.org/abs/{{paper.arxiv}}">ArXiV</a>
{% endfor %}
