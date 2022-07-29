# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as vim with context %}


{%- for user in vim.users | selectattr('vim.plug', 'defined') | selectattr('vim.plug') %}

vim-plug plugin manager is installed for user '{{ user.name }}':
  file.absent:
    - name: {{ user._vim.datadir | path_join('autoload', 'plug.vim') }}
{%- endfor %}
