{%- from 'tool-vim/map.jinja' import vim %}

include:
  - .package

{%- for user in vim.users | selectattr('vim.plug', 'defined') | selectattr('vim.plug') %}

vim-plug plugin manager is installed for user '{{ user.name }}':
  file.managed:
    - name: {{ user._vim.datadir }}/autoload/plug.vim
    - source: {{ user.vim.plug if user.vim.plug is string else 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' }}
    - skip_verify: true
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0644'
    - require:
        - vim setup is completed
{%- endfor %}
