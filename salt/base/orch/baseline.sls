{% set target = salt['pillar.get']('target', 'target_not_set') %}
{% if target == 'target_not_set' %}

baseline_error:
  test.configurable_test_state:
  - changes: False
  - result: False
  - comment: |
      You need to give a domain in a custom pillar to make this run!
      Example: salt-run state.orchestrate orch.baseline pillar='{target: "*.nhb.1nc" }'

{% else %}

{% set workspace = salt['grains.get']('workspace', 'NONE') %}

{% if workspace != 'NONE' %}
baseline_set_workspace:
  salt.state:
  - tgt: '{{ target }}'
  - saltenv: {{ workspace }}
  - sls:
    - workspace.set
{% endif %}

baseline_set_roles:
  salt.state:
  - tgt: '{{ target }}'
  - sls:
    - core.roles
{%- if workspace != 'NONE' %}
  - require:
    - salt: baseline_set_workspace
{%- endif %}

baseline_simulate_highstate:
  salt.state:
  - tgt: '{{ target }}'
  - sls:
    - core
    - debug.unlocked
    - sshd
  - require:
    - salt: baseline_set_roles

{% if workspace != 'NONE' %}
set_dev_repos:
  salt.state:
  - tgt: '{{ target }}'
  - saltenv: {{ workspace }}
  - sls:
    - core.apt
{% endif %}

{% endif %}