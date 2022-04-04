# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as vim with context %}


{%- for user in vim.users | rejectattr('xdg', 'sameas', False) %}

{%-   set user_default_conf = user.home | path_join(vim.lookup.paths.confdir, vim.lookup.paths.conffile) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(vim.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_datadir = user.xdg.data | path_join(vim.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(vim.lookup.paths.xdg_conffile) %}

Vim configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user_default_conf }}
    - source: {{ user_xdg_conffile }}

Vim does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_confdir }}
    - require:
      - Vim configuration is cluttering $HOME for user '{{ user.name }}'

Vim does not have its data folder in XDG_DATA_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_datadir }}

{%-   if user.get('persistenv') %}

Vim is ignorant about XDG location for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: >-
        ^{{ 'export VIMINIT="if has('nvim') | so ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim | else' ~
            ' | set nocp | so ${XDG_CONFIG_HOME:-$HOME/.config}/vim/xdg.vim | endif"' | regex_escape }}$
    - repl: ''
    - ignore_if_missing: true
{%-   endif %}
{%- endfor %}
