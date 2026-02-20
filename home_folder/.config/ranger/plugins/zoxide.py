import ranger.api
import subprocess
from ranger.api.commands import *

HOOK_INIT_OLD = ranger.api.hook_init


def hook_init(fm):
    def update_zoxide(signal):
        subprocess.Popen(["zoxide", "add", signal.new.path])

    fm.signal_bind("cd", update_zoxide)
    HOOK_INIT_OLD(fm)


ranger.api.hook_init = hook_init


class z(Command):
    """:z
    Uses zoxide to set the current directory.
    """

    def execute(self):
        try:
            # Run zoxide query to get the directory
            query = self.rest(1).split()
            directory = subprocess.check_output(["zoxide", "query"] + query)
            directory = directory.decode("utf-8", "ignore").strip()
            self.fm.execute_console("cd -r " + directory)
        except subprocess.CalledProcessError:
            self.fm.notify("zoxide: no match found", bad=True)
