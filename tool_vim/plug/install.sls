# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as vim with context %}

include:
  - {{ tplroot }}.package.install


{%- for user in vim.users | selectattr('vim.plug', 'defined') | selectattr('vim.plug') %}

vim-plug plugin manager is installed for user '{{ user.name }}':
  file.managed:
    - name: {{ user._vim.datadir | path_join('autoload', 'plug.vim') }}
    - source: {{ user.vim.plug if user.vim.plug is string else 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' }}
    - skip_verify: true
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0644'
    - dir_mode: '0755'
    - makedirs: true
    - require:
        - Vim setup is completed
{%- endfor %}
