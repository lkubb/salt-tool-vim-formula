{%- from 'tool-vim/map.jinja' import vim %}

include:
  - .package
{%- if vim.users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
{%- if vim.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  - .configsync
{%- endif %}
