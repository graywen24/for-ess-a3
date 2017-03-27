ldap:
  datadir: /var/storage/ldap
  backupdir: /var/storage/ldap_dump
  firstpass: ubuntu
  domain: cde.1nc
  suffix: dc=cde,dc=1nc
  organisation: 1-Net Singapore Pte Ltd
  cafile: CAS.service.chain.crt
  cert: ldap.cde
  bindto: eth0
  adminpass: e1NTSEF9SWpJUnEwVWRuQTNTajlSTVk2L1NZWjR0ZzQ2TTlBNC8=
  syncpass:
    real: taesh4de6joZumaegim0
    crypt: e1NTSEF9bU03cHF2QU1LcFVlZUx6RjFRM1ViUXBkMDdFWVRVMCs=
  servers:
    ldap-a1.cde.1nc:
      ip: 10.1.48.108
      role: master
      short: ldap-a1
    ldap-a2.cde.1nc:
      ip: 10.1.48.111
      role: slave
      short: ldap-a2
  len:
    url: 24
    suffix: 16

