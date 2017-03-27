;
; BIND data file for the 1nc domain
;
$TTL	604800
@	IN	SOA	localhost. root.localhost. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	   IN NS dns-a1.cde.1nc.
@	   IN NS dns-a2.cde.1nc.

; - physical hosts

{%- for host, ip in hosts.iteritems() %}
{{ "%-5s  IN   PTR   %s.%s."|format(ip, host, domain) }}
{%- endfor %}
