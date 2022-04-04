# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as vim with context %}

Vim is installed:
  pkg.installed:
    - name: {{ vim.lookup.pkg.name }}
    - version: {{ vim.get('version') or 'latest' }}
    {#- do not specify alternative return value to be able to unset default version #}

Vim setup is completed:
  test.nop:
    - name: Hooray, Vim setup has finished.
    - require:
      - pkg: {{ vim.lookup.pkg.name }}
