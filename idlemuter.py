# this script mutes your Mac after you've been idle for a few hours, unmutes it when you come back

import subprocess
import time
import envoy
import os

if os.getuid() != 0:
    raise Exception('need to run as sudo in order to change volume apparently')
print 'running'

def get_idle_time():
    # for some reason this didn't seem to work using envoy
    idle_command_string = """ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print $NF/1000000000; exit}'"""
    p = subprocess.Popen(idle_command_string, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out = p.stdout.read()
    return float(out)
        

def set_volume(volume):
    # volume 0-10
    envoy.run('''sudo osascript -e "set Volume {}"'''.format(volume))

idle_time = None
i_muted_it = False

while True:
    try:
        idle_time = get_idle_time()
    except:
        time.sleep(1)
        continue

    if not i_muted_it and idle_time > 60*60*3.5: #time in hours
        # mute
        set_volume(0)
        i_muted_it = True
    elif i_muted_it and idle_time < 2:
        # restore volume
        set_volume(3)
        i_muted_it = False

    time.sleep(1) 
