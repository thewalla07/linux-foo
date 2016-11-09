import os
#from commands import getoutput
#from socket import gethostname
#hostname = "this_machine"
#hostname = gethostname()
username = os.environ['USER']
pwd = os.getcwd()
homedir = os.path.expanduser('~')
pwd = pwd.replace(homedir, '~', 1)
if len(pwd) > 19:
    pwd = pwd[:6]+'...'+pwd[-10:] # first 7 chars+last 15 chars
#print(username+"@"+hostname+":"+pwd)
print(username+":"+pwd+" $ ")
