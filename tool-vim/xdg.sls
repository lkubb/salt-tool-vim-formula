{%- for user in salt['pillar.get']('tool:vim', []) | rejectattr('xdg', 'sameas', False) %}
  {%- from 'tool-vim/map.jinja' import user, xdg with context %}

Vim configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ xdg.config }}/vim/vimrc
    - source: {{ user.home }}/.vimrc
    - makedirs: true

Vim XDG configuration file is available for user '{{ user.name }}':
  file.managed:
    - name: {{ xdg.config }}/vim/xdg.vim
    - source: salt://tool-vim/files/xdg.vim
    - makedirs: true
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'

  {%- if user.persistenv | default(False) %}
Vim uses XDG configuration file for user '{{ user.name }}':
  file.append:
    - name: {{ user.persistenv }}
    - text: export VIMINIT="if has('nvim') | so ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim | else | set nocp | so ${XDG_CONFIG_HOME:-$HOME/.config}/vim/xdg.vim | endif"
  {%- endif %}
{%- endfor %}
