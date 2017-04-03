base:
  '*':
    - lxc_config
    - defaults
    - ldap
    - system
    - saltmine

cde:
  '*.cde.1nc and not G@workspace:bbox':
    - match: compound
    - defaults
  '*.cde.1nc':
    - hosts
    - containers
  '*.cde.1nc and G@roles:ldapmgr':
    - match: compound
    - lam
  '*.cde.1nc and G@roles:smsgw':
    - match: compound
    - desms
  '*.cde.1nc and G@roles:twofa':
    - match: compound
    - defa
  '*.cde.1nc and G@roles:smarthost':
    - match: compound
    - smarthost
nhb:
  '*.nhb.1nc and not G@workspace:bbox':
    - match: compound
    - defaults
    - hosts
    - containers
  'roles:cdos':
    - match: grain
    - cdos
  'roles:cdostmp':
    - match: grain
    - cdos
vstage:
  '*.vstage.1nc and not G@workspace:bbox':
    - match: compound
    - defaults
    - hosts
    - containers
  'roles:cdos':
    - match: grain
    - cdos
  'roles:cdostmp':
    - match: grain
    - cdos
wcc:
  '*.wcc.1nc and not G@workspace:bbox':
    - match: compound
    - defaults
    - hosts
    - containers
  'roles:cdos':
    - match: grain
    - cdos
  'roles:cdostmp':
    - match: grain
    - cdos
