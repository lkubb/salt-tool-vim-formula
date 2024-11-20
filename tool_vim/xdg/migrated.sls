# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as vim with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ tplroot }}.package


{%- for user in vim.users | rejectattr("xdg", "sameas", false) %}

{%-   set user_default_conf = user.home | path_join(vim.lookup.paths.confdir, vim.lookup.paths.conffile) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(vim.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(vim.lookup.paths.xdg_conffile) %}

# workaround for file.rename not supporting user/group/mode for makedirs
Vim has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user_xdg_confdir }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true
    - onlyif:
      - test -e '{{ user_default_conf }}'

Existing Vim configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user_xdg_conffile }}
    - source: {{ user_default_conf }}
    - require:
      - Vim has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - Vim setup is completed

Vim XDG configuration file is available for user '{{ user.name }}':
  file.managed:
    - name: {{ user_xdg_confdir | path_join("xdg.vim") }}
    - source: {{ files_switch(
                    ["xdg.vim"],
                    lookup="Vim XDG configuration file is available for user '{{ user.name }}'",
                    config=vim,
                    custom_data={"users": [user.name]},
                 )
              }}
    - makedirs: true
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - dir_mode: '0700'
    - require_in:
        - Vim setup is completed

{%-   if user.get("persistenv") %}

persistenv file for Vim exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.persistenv) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

Vim knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: >-
        export VIMINIT="if has('nvim') | so ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim
        | else | set nocp | so ${XDG_CONFIG_HOME:-$HOME/.config}/vim/xdg.vim | endif"
    - require:
      - persistenv file for Vim exists for user '{{ user.name }}'
    - require_in:
      - Vim setup is completed
{%-   endif %}
{%- endfor %}
