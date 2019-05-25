# cli/commands/bye.py
"""The bye command."""
 
 
from json import dumps
 
from .base import Base
 
 
class Bye(Base):
    """Say Bye bye!"""
 
    def run(self):
        print('Bye bye!')
        print('You supplied the following options:', dumps(self.options, indent=2, sort_keys=True))
