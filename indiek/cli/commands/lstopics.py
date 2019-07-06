# cli/commands/lstopics.py
"""The lstopics command."""

from indiek.core.indiek_core import *

from .base import Base


class Lstopics(Base):
    """Say Bye bye!"""
    def run(self):
        print('lstopics is running')
        with session() as db:
            print('in the with block')
            s = UserInterface(db)
            s.list_topics()
