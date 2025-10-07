#vconnect starter file
#Created by referencing lab material created by rtgillen

import json
with open('vcenter-conf.json', 'r') as f:
    vcenter_conf = json.load(f)

import getpass
passw = getpass.getpass()
from pyVim.connect import SmartConnect
import ssl
s=ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
s.verify_mode=ssl.CERT_NONE
si=SmartConnect(host=vcenter_conf['vcenter'][0]['vcenterhost'], user=vcenter_conf['vcenter'][0]['vcenteradmin'], pwd=passw, sslContext=s)
aboutInfo=si.content.about
print(aboutInfo)
