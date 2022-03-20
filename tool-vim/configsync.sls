{%- from 'tool-vim/map.jinja' import vim %}

include:
  - .package
{%- if vim.users | selectattr('vim.plug_install', 'defined') | selectattr('vim.plug_install') | list %}
  - .plug
{%- endif %}

{%- for user in vim.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
    {%- set dotconfig = user.dotconfig if dotconfig is mapping else {} %}

vim configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user.xdg.config }}/vim
    - source:
      - salt://dotconfig/{{ user.name }}/vim
      - salt://dotconfig/vim
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
  {%- if dotconfig.get('file_mode') %}
    - file_mode: '{{ dotconfig.file_mode }}'
  {%- endif %}
    - dir_mode: '{{ dotconfig.get('dir_mode', '0700') }}'
    - clean: {{ dotconfig.get('clean', False) | to_bool }}
    - makedirs: True
    - require_in:
        - vim setup is completed

  {%- if user.vim.get('plug_install') %}
Defined plugins from config are installed for user '{{ user.name }}':
  cmd.run:
    - name: vim -c 'PlugInstall' -c 'qa!'
    - runas: {{ user.name }}
    - onchanges:
      - vim configuration is synced for user '{{ user.name }}'
    - require:
      - vim-plug plugin manager is installed for user '{{ user.name }}'
  {%- endif %}
{%- endfor %}
