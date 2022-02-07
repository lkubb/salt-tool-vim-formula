{%- from 'tool-vim/map.jinja' import vim %}

include:
  - .package
{%- if vim.users | rejectattr('xdg', 'sameas', False) | list %}
  - .xdg
{%- endif %}
{%- if vim.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
  - .configsync
{%- endif %}
{%- if vim.users | selectattr('vim.plug', 'defined') | selectattr('vim.plug') | list %}
  - .plug
{%- endif %}
