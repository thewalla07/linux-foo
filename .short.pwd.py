import os
from commands import getoutput
from socket import gethostname
hostname = "this_machine"
#hostname = gethostname()
username = os.environ['USER']
pwd = os.getcwd()
homedir = os.path.expanduser('~')
pwd = pwd.replace(homedir, '~', 1)
if len(pwd) > 30:
    pwd = pwd[:7]+'...'+pwd[-15:] # first 7 chars+last 15 chars
#print '[%s@%s:%s] ' % (username, hostname, pwd)
print '%s:%s ' % (username, pwd)
