include:
  - .package
{%- if salt['pillar.get']('tool:vim') | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
