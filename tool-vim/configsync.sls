{%- from 'tool-vim/map.jinja' import vim %}

{%- for user in vim.users | selectattr('dotconfig') %}
vim configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user.xdg.config }}/vim
    - source:
      - salt://user/{{ user.name }}/dotfiles/vim
      - salt://user/dotfiles/vim
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
{%- endfor %}
