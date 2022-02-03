{%- from 'tool-vim/map.jinja' import vim %}

include:
  - .package

{%- for user in vim.users | rejectattr('xdg', 'sameas', False) %}
Vim configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/vim/vimrc
    - source: {{ user.home }}/.vimrc
    - makedirs: true
    - require_in:
        - vim setup is completed

Vim XDG configuration file is available for user '{{ user.name }}':
  file.managed:
    - name: {{ user.xdg.config }}/vim/xdg.vim
    - source: salt://tool-vim/files/xdg.vim
    - makedirs: true
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - require_in:
        - vim setup is completed

  {%- if user.persistenv | default(False) %}

persistenv file for vim for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home }}/{{ user.persistenv }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

Vim uses XDG configuration file for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export VIMINIT="if has('nvim') | so ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim | else | set nocp | so ${XDG_CONFIG_HOME:-$HOME/.config}/vim/xdg.vim | endif"
    - require:
      - persistenv file for vim for user '{{ user.name }}' exists
  {%- endif %}
{%- endfor %}
