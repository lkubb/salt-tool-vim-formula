# vim: ft=sls

{#-
    Manages the Vim package configuration by

    * recursively syncing from a dotfiles repo

    Has a dependency on `tool_vim.package`_.
#}

include:
  - .sync
