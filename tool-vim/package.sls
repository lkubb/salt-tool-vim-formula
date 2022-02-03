vim is installed:
  pkg.installed:
    - name: vim

vim setup is completed:
  test.nop:
    - name: Hooray, vim setup has finished.
    - require:
      - pkg: vim
