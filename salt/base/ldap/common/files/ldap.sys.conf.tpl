{% macro get_serverlist() -%}
{% set space = ' ' -%}
{%- for key, serverinfo in pillar.ldap['servers']|dictsort() -%}
{{ space }}ldaps://{{ serverinfo.ip }}/
{%- endfor %}
{%- endmacro %}
#
# LDAP Defaults
#

# See ldap.conf(5) for details
# This file should be world readable but not world writable.

BASE	{{ pillar.ldap.suffix}}
URI {{ get_serverlist() }}

#SIZELIMIT	12
#TIMELIMIT	15
#DEREF		never

# TLS certificates (needed for GnuTLS)
TLS_CACERT	{{ pillar.system.ssldir }}/{{ pillar.ldap.cafile }}

