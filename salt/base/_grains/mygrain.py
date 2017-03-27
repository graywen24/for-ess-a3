#!/usr/bin/env python

# Import python libs
from __future__ import absolute_import
import logging
import random

import salt.utils.dictupdate as udict

# Set up logging
log = logging.getLogger(__name__)

# __grains__ = salt.loader.grains(__opts__)

def myfunction():
    # initialize a grains dictionary
    grains = {}
    # Some code for logic that sets grains like
    # grains['myroles']=__salt__['grains.get']('nodename')
    grains['mygrain']='somevalue'
    return grains