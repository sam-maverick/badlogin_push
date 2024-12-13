import subprocess
import time
import os
from datetime import datetime

auditlogfile = open('/var/log/auth.log','r')

# Linux does not store creation time. We use the previous log as an indicator
logcreationtime = os.path.getmtime('/var/log/auth.log.1')

def do_log(message, mylogfile):
    global logcreationtime, auditlogfile
    now = datetime.now()
    dt_string = now.strftime("%Y%m%d_%H:%M:%S ")
    #print (dt_string + message)
    mylogfile.write(dt_string + message + "\r\n")
    mylogfile.flush()
    
    
def follow(thefile, mylogfile):
    global logcreationtime, auditlogfile
    thefile.seek(0, os.SEEK_END) # Go to the end of the file
    keepalive = ''
    while True:
        # keep-alive checks for the log
        now = datetime.now()
        keepalive_new = str(now.strftime("%Y%m%d"))
        if (keepalive != keepalive_new):
            keepalive = keepalive_new
            do_log('keepalive', mylogfile)

        #non-blocking read
        line = thefile.readline()
        if not line:
            # check if log has been rotated
            if (logcreationtime != os.path.getmtime('/var/log/auth.log.1')):
                do_log("/var/log/auth1.log has been rotated", mylogfile)
                do_log("variable value:" + str(logcreationtime), mylogfile)
                do_log("file value:" + str(os.path.getmtime('/var/log/auth.log.1')), mylogfile)
                auditlogfile = open('/var/log/auth.log','r')
                logcreationtime = os.path.getmtime('/var/log/auth.log.1')
                continue

            # if log not rotated and read gives nothing, sleep for a while
            time.sleep(3) # Sleep briefly [seconds]
            continue

        line = line.replace('"', '')
        line = line.replace("\n", '')
        line = line.replace("\r", '')
        subprocess.call(['$HOME/software/code/badlogin_checkline.sh', line])

print("Python program started\n")
#with open('$HOME/software/code/badlogin_sentinel.log', 'a') as bllogfile:
bllogfile = open("$HOME/software/logs/badlogin_sentinel.log", "a")  # append mode
do_log("Sentinel started", bllogfile)
follow(auditlogfile, bllogfile)

