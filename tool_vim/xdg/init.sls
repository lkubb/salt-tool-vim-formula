# vim: ft=sls

{#-
    Ensures Vim adheres to the XDG spec
    as best as possible for all managed users.
    Has a dependency on `tool_vim.package`_.
#}

include:
  - .migrated
