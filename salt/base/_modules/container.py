'''
module to get containers controlled

'''

# Import python libs
from __future__ import absolute_import
import logging
import random

import salt.utils.dictupdate as udict

# Set up logging
log = logging.getLogger(__name__)

# Import salt libs
#import salt.utils
#from salt.exceptions import CommandExecutionError, SaltInvocationError



def _getcontainerlist(node, name=None,role=None,):

    containers_pillar = __salt__['pillar.get']('containers')
    containerlist={}

    for key, container in containers_pillar.iteritems():
        if not any((name,role)):
            if container['target'] == node:
                containerlist[key] = {"target": container['target']}
        elif name and not role:
            if name == key and container['target'] == node:
                containerlist[key] = {"target": container['target']}
        elif not name and role:
            if role in container['roles'] and container['target'] == node:
                containerlist[key] = {"target": container['target']}
        else:
            if name == key and container['target'] == node and role in container['roles']:
                containerlist[key] = {"target": container['target']}

    return containerlist


def _containeraction(state, prefix, name=None, role=None, test=False, profile='ubuntu'):

    ret = {'result': True,
           'comment': 'Container \'{0}\' already exists'.format(name),
           'changes': {}}

    node = __salt__['grains.get']('nodename')
    containerlist = _getcontainerlist(node, name, role)
    if len(containerlist) == 0:
        ret['comment'] = 'No containers for target \'{1}\': Filter role={0};name={2}'.format(role, node, name)
        return ret

    pl = {}
    for key, container in containerlist.iteritems():
        if test == False:
            pl['container'] = key
            pl['profile'] = profile
            ret['changes'][key]=__salt__['state.sls'](mods=state, pillar=pl)
        else:
            ret['changes'][key]="{0} target {1}".format(prefix, node)

    ret['comment'] = 'Found containers for target \'{1}\': Filter role={0};name={2}'.format(role, node, name)
    return ret


# Container existence/non-existence
def deployed(name=None, role=None, test=True, profile='ubuntu'):

    ret = _containeraction('container.deployed', "Installing to", name, role, test, profile)
    return ret


# Container existence/non-existence
def destroyed(name=None, role=None, test=True):

    ret = _containeraction('container.destroyed', "Destroying on", name, role, test)
    return ret

def purged(name=None, role=None, test=True):

    ret = _containeraction('container.purged', "Purging on", name, role, test)
    return ret


