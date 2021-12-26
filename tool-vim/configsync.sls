{%- for user in salt['pillar.get']('tool:vim', salt['pillar.get']('tool:users', [])) %}
  {%- from 'tool-vim/map.jinja' import user, xdg with context %}
vim configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ xdg.config }}/vim
    - source:
      - salt://user/{{ user.name }}/dotfiles/vim
      - salt://user/dotfiles/vim
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
{%- endfor %}
