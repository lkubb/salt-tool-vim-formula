# vim: ft=sls

{#-
    Syncs the Vim package configuration
    with a dotfiles repo.
    Has a dependency on `tool_vim.package`_
    and `tool_vim.plug`_ if `vim.plug_install` is set to true.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as vim with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}

{%- if vim.users | selectattr("vim.plug_install", "defined") | selectattr("vim.plug_install") | list %}

include:
  - .plug
{%- endif %}

{%- for user in vim.users | selectattr("dotconfig", "defined") | selectattr("dotconfig") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}

Vim configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user["_vim"].confdir }}
    - source: {{ files_switch(
                    ["vim"],
                    lookup="Vim configuration is synced for user '{}'".format(user.name),
                    config=vim,
                    path_prefix="dotconfig",
                    files_dir="",
                    custom_data={"users": [user.name]},
                 )
              }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
{%-   if dotconfig.get("file_mode") %}
    - file_mode: '{{ dotconfig.file_mode }}'
{%-   endif %}
    - dir_mode: '{{ dotconfig.get("dir_mode", "0700") }}'
    - clean: {{ dotconfig.get("clean", false) | to_bool }}
    - makedirs: true

{%-   if user.vim.get("plug_install") %}

Defined plugins from config are installed for user '{{ user.name }}':
  cmd.run:
    - name: vim -c 'PlugInstall' -c 'qa!'
    - runas: {{ user.name }}
    - onchanges:
      - vim configuration is synced for user '{{ user.name }}'
    - require:
      - vim-plug plugin manager is installed for user '{{ user.name }}'
{%-   endif %}
{%- endfor %}
