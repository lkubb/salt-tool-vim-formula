# vim: ft=sls

{#-
    Removes the configuration of the Vim package.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as vim with context %}


{%- for user in vim.users %}

Vim config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_vim"].conffile }}

{%-   if user.xdg %}

Vim config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_vim"].confdir }}
{%-   endif %}
{%- endfor %}
