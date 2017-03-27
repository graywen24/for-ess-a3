'''
Expose maas helper functions

'''

# Import python libs
from __future__ import absolute_import
import salt

from apiclient.maas_client import (
    MAASClient,
    MAASDispatcher,
    MAASOAuth,
)
from salt.exceptions import CommandExecutionError
import json
import urllib2

# Set up logging
import logging
logger = logging.getLogger(__name__)

maasra = '/usr/sbin/maas-region-admin'

def __virtual__():
    if salt.utils.which('maas-region-admin'):
        return True
    return False

def _getclient(url=u'http://localhost/MAAS/api/1.0/'):
    consumer_key, token, secret = key('root').split(':', 3)
    auth = MAASOAuth(consumer_key, token, secret)
    dispatch = MAASDispatcher()
    client = MAASClient(auth, dispatch, url)
    return client

def _mget(path):
    try:
        resp = _getclient().get(path).read()
        logger.info('GET result: %s', resp)
        return json.loads(resp)
    except urllib2.HTTPError as e:
        logger.error("HTTP error: " + e.read())

    return


def _mpost(path, op, **kwargs):
    path = path.strip("/") + u"/"
    try:
        resp = _getclient().post(path, u'list').read()
        logger.info('POST result: %s', resp)
        return json.loads(resp)
    except urllib2.HTTPError as e:
        logger.error("HTTP error: " + e.read())

    return

def _mput(path, **kwargs):
    path = path.strip("/") + u"/"
    try:
        resp = _getclient().put(path, **kwargs).read()
        logger.info('PUT result: %s', resp)
        return json.loads(resp)
    except urllib2.HTTPError as e:
        logger.error("HTTP error: " + e.read())

    return

def key(name):
    apikey = __salt__['cmd.run_all']('{0} apikey --username={1}'.format(maasra, name))
    if not apikey['retcode'] == 0:
        raise CommandExecutionError(apikey['stderr'])

    return apikey['stdout']


def nodes(params=None):
    return _mget(u'nodes')


def users(params=None):
    return _mget(u'users')


def zones(params=None):
    return _mget(u'zones')

def config(params=None):
    return _mget(u'maas/?op=get_config&name=commissioning_distro_series')

def bootsources(op='list', id=None, url=None):

    if op == 'list':
        urlargs = [u'boot-sources']
        path = '/'.join(unicode(element) for element in urlargs) + '/'
        return _mget(path)

    if op == 'update':
        if id is None:
            raise CommandExecutionError('ID cant be empty!')

        if url is None:
            raise CommandExecutionError('URL cant be empty!')

        urlargs = [u'boot-sources', id]
        path = '/'.join(unicode(element) for element in urlargs) + '/'

        return _mput(path, url=url)

