---
layout: default
title: mhoffman.github.com/papers/
---

# Papers

<hr />

{% for paper in site.data.publications %}
1. **{{ paper.title}}**

   {{ paper.authors }} _{{ paper.journal }}_ ({{ paper.date}})
   {% if paper.doi %} <a href='http://dx.doi.org/{{ paper.doi }}'>DOI: {{ paper.doi }}</a> | {% endif %} {% if paper.arxiv %} <a href="http://arxiv.org/abs/{{paper.arxiv}}">ArXiv:{{paper.arxiv}}</a> <a href="https://www.arxiv-vanity.com/papers/{{paper.arxiv}}/">HTML</a> {% endif %}
{% endfor %}
