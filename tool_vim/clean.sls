# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_vim`` meta-state
    in reverse order.
#}

include:
  - .plug.clean
  - .config.clean
  - .package.clean
