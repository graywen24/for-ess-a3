lxc.container_profile:
  ubuntu:
    template: ubuntu-alchemy
    options:
      arch: amd64
      release: trusty
      mirror: http://repo.cde.1nc/cde/ubuntu
      security-mirror: http://repo.cde.1nc/cde/ubuntu
  cde-bootstrap:
    template: ubuntu-alchemy
    resolver: False
    options:
      arch: amd64
      release: trusty
      mirror: http://10.3.50.10/cde/ubuntu
      security-mirror: http://10.3.50.10/cde/ubuntu
      repoip: 10.3.50.10
      profile: cde-bootstrap
