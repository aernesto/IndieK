"""Tests for our `ik bye` subcommand."""


from subprocess import PIPE, Popen as popen
from unittest import TestCase


class TestBye(TestCase):
    def test_returns_multiple_lines(self):
        output = popen(['ik', 'bye'], stdout=PIPE).communicate()[0]
        lines = output.decode('utf-8').split('\n')
        self.assertTrue(len(lines) != 1)

    def test_returns_hello_world(self):
        output = popen(['ik', 'bye'], stdout=PIPE).communicate()[0]
        self.assertTrue('Bye bye!' in output.decode('utf-8'))
