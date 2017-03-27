'''
Expose alchemy helper functions

'''

# Import python libs
from __future__ import absolute_import
import logging
import random

import salt.utils.dictupdate as udict

# Set up logging
log = logging.getLogger(__name__)

def _getHwaddr(prefix):
    mac = [ random.randint(0x00, 0xff),
            random.randint(0x00, 0xff),
            random.randint(0x00, 0xff) ]
    return prefix + ':' + ':'.join(map(lambda x: "%02x" % x, mac))

def _mklxcnetworkconf(name, ifconfig, ifdefaults):

    ret = {}

    ret['type'] = ifconfig.get("type", ifdefaults.get("type", "veth"))
    ret['flags'] = ifconfig.get("flags", ifdefaults.get("flags", "up"))
    ret['name'] = ifconfig.get("name", ifdefaults.get("name", "eth0"))
    ret['link'] = ifconfig.get("link", ifdefaults.get("link", "br0"))
    ret['hwaddr'] = ifconfig.get("hwaddr", _getHwaddr(ifdefaults.get("macprefix", "00:ee:1e")))
    ret['domain'] = ifconfig.get("domain", ifdefaults.get("domain", "none.1nc"))
    ret['fqdn'] = "{0}.{1}".format(name, ret['domain'])

    if ret['type'] == "veth":
        vpref = ifdefaults.get("vpref", "na")
        vname = name
        suffix = ''
        maxlen = 15

        if len(vpref) > 0:
            maxlen -= 1

        hasdotat = vname.find(".")
        if hasdotat > 0:
            vname = vname[0:hasdotat]

        hasdash = vname.rfind("-")
        if hasdash > 0:
            suffix = vname[hasdash+1:]
            vname = vname[0:hasdash]
            maxlen -= 1

        shortlen = maxlen - len(vpref) - len(suffix)
        shortname = vname[0:shortlen]
        ret['vname'] = "-".join([vpref, shortname, suffix]).strip("-")

    ret['ipv4'] = ifdefaults['ip4net'].format(ifconfig.get("ip4", "100"))

    if ifconfig.has_key('gateway'):
        ret['gateway'] = ifconfig.get("gateway")
    elif ifdefaults.has_key('gateway'):
        ret['gateway'] = ifdefaults.get("gateway")

    if ifconfig.has_key('postup'):
        ret['postup'] = ifconfig.get("postup")
    elif ifdefaults.has_key('postup'):
        ret['postup'] = ifdefaults.get("postup")

    return ret

def _mkhostnetworkconf(name, ifconfig, ifdefaults):

    ret = {}

    ret['type'] = ifconfig.get("type", ifdefaults.get("type", "eth"))
    ret['phys'] = ifconfig.get("phys", ifdefaults.get("phys", "eth2"))
    ret['domain'] = ifconfig.get("domain", ifdefaults.get("domain", "none.1nc"))
    ret['link'] = ifconfig.get("link", ifdefaults.get("link", "br0"))
    ret['fqdn'] = "{0}.{1}".format(name, ret['domain'])
    ret['ipv4'] = ifdefaults['ip4net'].format(ifconfig.get("ip4", "100"))

    # if ifconfig.has_key('bond'):
    ret['bond'] = ifconfig.get("bond", ifdefaults.get("bond", []))

    if ifconfig.has_key('gateway'):
        ret['gateway'] = ifconfig.get("gateway")
    elif ifdefaults.has_key('gateway'):
        ret['gateway'] = ifdefaults.get("gateway")

    return ret


def host(name):
    config_path = 'hosts:' + name
    config = __salt__['pillar.get'](config_path, {})

    defaults = __salt__['pillar.get']('defaults', {})
    host_defaults = defaults.get('hosts', {})
    host_net_defaults = host_defaults.get('network', {})

    config['envname'] = "{0}.{1}".format(name, defaults['env'])

    for interface, configuration in config.get('network', {}).iteritems():
        if not configuration.has_key("ip4"):
            configuration['ip4'] = config.get("ip4", "X")

        config['network'][interface] = _mkhostnetworkconf(name, configuration, host_net_defaults[interface])

    # config = udict.merge_recurse(host_defaults, config)

    return config


def host_fqdns(preselect=""):

    if preselect != '':
        return [preselect]

    envnames = []
    hosts = __salt__['pillar.get']('hosts', {}).keys()
    env = __salt__['pillar.get']('defaults:env', "")
    for host in hosts:
        envnames.append("{0}.{1}".format(host, env))

    return envnames

def strip_env(nodename):
    fqdnparts = nodename.split(".")
    return fqdnparts[0]

def host_list(preselect=""):

    if preselect != '':
        return [preselect]

    return __salt__['pillar.get']('hosts', {}).keys()


def container(name):
    config_path = 'containers:' + name
    config = __salt__['pillar.get'](config_path, {})

    defaults = __salt__['pillar.get']('defaults', {})
    host_defaults = defaults.get('hosts', {})
    host_net_defaults = host_defaults.get('network', {})
    container_defaults = defaults.get('containers', {})
    container_net_defaults = container_defaults.get('network', {})

    config['envname'] = "{0}.{1}".format(name, defaults['env'])

    for interface, configuration in config.get('network', {}).iteritems():
        if not configuration.has_key("ip4"):
            configuration['ip4'] = config.get("ip4", "X")

        lxc_net_defaults = udict.merge(host_net_defaults[interface], container_net_defaults.get('common', {}))
        config['network'][interface] = _mklxcnetworkconf(name, configuration, lxc_net_defaults)

    config = udict.merge_recurse(container_defaults.get("common", {}), config)
    config['lxcconf'] = udict.merge_recurse(container_defaults.get("lxcconf", {}), config.get("lxcconf", {}))
    config['roles'] = list(set(container_defaults.get("roles", []) + config.get("roles", [])))

    config['mount'] = udict.merge_recurse(container_defaults.get("mount", {}), config.get("mount", {}))
    for mountid, mount in config.get("mount", {}).iteritems():
        mount['local'] = mount['local'].format(config['envname'])
        mount['remote'] = mount['remote'].format(config['envname']).strip("/")

    config['target'] = "{0}.{1}".format(config['target'], defaults['env'])
    return config

def container_list(preselect=""):

    if preselect != '':
        return [preselect]

    return __salt__['pillar.get']('containers', {}).keys()

def container_target(name):
    # config_path = 'containers:' + name + ":target"
    config = container(name)
    return config.get('target', 'target_not_set')

def roles(name=None, merge=True):

    result = []

    if name is None:
        name = __salt__['grains.get']('nodename', "")
    log.warning("Name: %s", name)

    defaults = __salt__['pillar.get']('defaults:hosts:roles', [])

    path = 'hosts:' + name + ':roles'
    host = __salt__['pillar.get'](path, [])

    path = 'containers:' + name + ':roles'
    container = __salt__['pillar.get'](path, [])

    log.warning("defaults: %s", defaults)
    log.warning("host: %s", host)
    log.warning("container: %s", container)

    container_defaults = []
    if len(container) > 0:
        container_defaults = __salt__['pillar.get']('defaults:containers:roles', [])

    log.warning("container defaults: %s", container_defaults)

    defaults = defaults + container_defaults
    host = host + container

    log.warning("defaults with container defaults: %s", defaults)
    log.warning("host with container config: %s", host)

    if merge:
        result = defaults

    log.warning("result has defaults: %s", result)
    result = result + host

    log.warning("result: %s", result)
    return result

def zones():

    result = {}

    networks = __salt__['pillar.get']('defaults:hosts:network', {})
    hosts = __salt__['pillar.get']('hosts', {})
    containers = __salt__['pillar.get']('containers', {})

    for network, networkinfo in networks.iteritems():
        log.info("working on network %s, %s", network, networkinfo)
        if not networkinfo.has_key('domain'):
            continue

        zonedata = {}
        zonedata['nodes'] = {}
        hostdata = {}
        containerdata = {}
        ipnet = networkinfo['ip4net'].split("/")[0]

        for node, nodedata in hosts.iteritems():
            log.info("working on node %s, %s", node, nodedata)
            if not nodedata['network'].has_key(network):
                continue

            hostdata[node] = { 'revip': nodedata['ip4'], 'ip': ipnet.format(nodedata['ip4']) }

        for node, nodedata in containers.iteritems():
            log.info("working on node %s, %s", node, nodedata)
            if not nodedata['network'].has_key(network):
                continue

            containerdata[node] = { 'revip': nodedata['ip4'], 'ip': ipnet.format(nodedata['ip4']) }

        if len(hostdata) == 0 and len(containerdata) == 0:
            continue

        zonedata['nodes']['hosts'] = hostdata
        zonedata['nodes']['containers'] = containerdata
        zonedata['reverse'] = ipnet.format("0")
        result[networkinfo['domain']] = zonedata

    return result