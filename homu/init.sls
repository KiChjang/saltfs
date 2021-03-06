python3:
  pkg.installed:
    - pkgs:
      - python3

homu:
  git.latest:
    - name: https://github.com/servo/homu
    - rev: e07f74e7a3a185768e71639d6a328ef8ea234f92
    - target: /home/servo/homu
    - user: servo
  virtualenv.managed:
    - name: /home/servo/homu/_venv
    - venv_bin: virtualenv-3.4
    - python: python3
    - system_site_packages: False
    - require:
      - pkg: python3
      - pip: virtualenv
  pip.installed:
    - bin_env: /home/servo/homu/_venv
    - editable: /home/servo/homu
    - require:
      - git: homu
      - virtualenv: /home/servo/homu/_venv
  service.running:
    - enable: True
    - require:
      - pip: homu
    - watch:
      - file: /home/servo/homu/cfg.toml
      - file: /etc/init/homu.conf

/home/servo/homu/cfg.toml:
  file.managed:
    - source: salt://homu/cfg.toml
    - template: jinja
    - user: servo
    - group: servo
    - mode: 644

/etc/init/homu.conf:
  file.managed:
    - source: salt://homu/homu.conf
    - user: root
    - group: root
    - mode: 644
