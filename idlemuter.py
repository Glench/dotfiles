# mutes your computer after you've been idle for a few hours, unmutes it when you come back

import subprocess
import time
import envoy
import rumps
import os

if os.getuid() != 0:
    raise Exception('need to run as sudo')

def get_idle_time():
    # for some reason this didn't seem to work using envoy
    idle_command_string = """ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print $NF/1000000000; exit}'"""
    p = subprocess.Popen(idle_command_string, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out = p.stdout.read()
    return float(out)
        

def set_volume(volume):
    # volume 0-10
    envoy.run('''sudo osascript -e "set Volume {}"'''.format(volume))


# rumps app lets a python script live in the osx status bar
class AwesomeStatusBarApp(rumps.App):
    def __init__(self):
        super(AwesomeStatusBarApp, self).__init__("m")
        self.menu = ["mute when idle active"]

        self.i_muted_it = False

    @rumps.clicked("mute when idle active")
    def menu_click(self, _):
        rumps.alert("this menu item doesn't do anything. see dotfiles/idlemuter.py ")

    @rumps.timer(1)
    def mute(self, sender):
        try:
            idle_time = get_idle_time()
        except:
            return

        if not self.i_muted_it and idle_time > 60*60*3.5:
            # mute
            set_volume(0)
            self.i_muted_it = True
        elif self.i_muted_it and idle_time < 2:
            # restore volume
            set_volume(3)
            self.i_muted_it = False


if __name__ == "__main__":
    AwesomeStatusBarApp().run()
