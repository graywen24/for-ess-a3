{% if 'host' in grains.get('roles', []) %}
default_grub:
  file.managed:
    - name: /etc/default/grub
    - source: salt://core/files/grub.default

rebuild_grub:
  cmd.run:
    - name: /usr/sbin/update-grub
    - onchanges:
      - file: default_grub

{% else %}

{{ grains.id }}_no_work:
  test.configurable_test_state:
    - comment: Nothing to do! This state only applies to minions with the 'host' role!
    - changes: False
    - result: True

{% endif %}