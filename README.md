# `vim` Formula
Sets up, configures and updates `vim` version manager and some selected tools for development environments.

## Usage
Applying `tool-vim` will make sure `vim` is configured as specified.

## Configuration
### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

#### User-specific
The following shows an example of `tool-vim` pillar configuration. Namespace it to `tool:users` and/or `tool:vim:users`.
```yaml
user:
  xdg: true      # force xdg dirs
  # sync this user's config from a dotfiles repo available as
  # salt://dotconfig/<user>/karabiner or salt://dotconfig/karabiner
  dotconfig: true
  # persist vim env vars to use xdg dirs permanently
  # (will be appended to file relative to $HOME)
  persistenv: '.config/zsh/zshenv'
  vim:
    plug: false  # install vim-plug plugin manager
```

#### Formula-specific
```yaml
tool:
  vim:
    defaults:
      plug: false  # install vim-plug plugin manager
```

### Dotfiles
`tool-vim.configsync` will recursively apply templates from 

- `salt://dotconfig/<user>/vim` or
- `salt://dotconfig/vim`

to the user's config dir for every user that has it enabled (see `user.dotconfig`). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).
