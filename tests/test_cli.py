"""Tests for our main skele CLI module."""


from subprocess import PIPE, Popen
from unittest import TestCase

from indiek.cli import __version__ as VERSION


class TestHelp(TestCase):
    def test_returns_usage_information(self):
        output = Popen(['ik', '-h'], stdout=PIPE).communicate()[0]
        self.assertTrue('Usage:'.encode('utf-8') in output)

        output = Popen(['ik', '--help'], stdout=PIPE).communicate()[0]
        self.assertTrue('Usage:'.encode('utf-8') in output)


class TestVersion(TestCase):
    def test_returns_version_information(self):
        output = Popen(['ik', '--version'], stdout=PIPE).communicate()[0]
        self.assertEqual(output.strip(), VERSION.encode('utf-8'))
