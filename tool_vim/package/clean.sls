# vim: ft=sls

{#-
    Removes the Vim package.
    Has a dependency on `tool_vim.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as vim with context %}

include:
  - {{ sls_config_clean }}


Vim is removed:
  pkg.removed:
    - name: {{ vim.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
