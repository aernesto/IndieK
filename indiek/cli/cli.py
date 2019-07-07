"""
ik
 
Usage:
  ik hello
  ik lstopics
  ik bye
  ik -h | --help
  ik --version
 
Options:
  -h --help                         Show this screen.
  --version                         Show version.
 
Examples:
  ik hello
  ik bye
  ik lstopics
 
Help:
  For help using this tool, please open an issue on the Github repository:
  https://github.com/indiek/indiek.cli
"""
 
 
from inspect import getmembers, isclass
 
from docopt import docopt
 
from . import __version__ as VERSION
 
 
def main():
    """Main CLI entrypoint."""
#    import sys
#    print(sys.path)
    import indiek.cli.commands as commands  # each command lives in a file with same name
    options = docopt(__doc__, version=VERSION)
    # print(options)

    # Here we'll try to dynamically match the command the user is trying to run
    # with a pre-defined command class we've already created.
    for k, v in options.items():
        if v and hasattr(commands, k):
            # print(k)  # k here is the command as a string, e.g. hello or lstopics
            module = getattr(commands, k)  # this grabs the module with filename identical to the command
            classes = getmembers(module, isclass)  # list of (class name, class object) pairs
            # print(classes)
            command = [c[1] for c in classes if c[0] == k.capitalize()][0]
            # command = classes_list[0]  # grabs first class, this was not robust
            # print(type(command))
            # print(command)
            command = command(options)
            command.run()
