"""Tests for our `ik hello` subcommand."""


from subprocess import PIPE, Popen as popen
from unittest import TestCase


class TestHello(TestCase):
    def test_returns_multiple_lines(self):
        output = popen(['ik', 'hello'], stdout=PIPE).communicate()[0]
        lines = output.decode('utf-8').split('\n')
        self.assertTrue(len(lines) != 1)

    def test_returns_hello_world(self):
        output = popen(['ik', 'hello'], stdout=PIPE).communicate()[0]
        self.assertTrue('Hello, world!' in output.decode('utf-8'))
