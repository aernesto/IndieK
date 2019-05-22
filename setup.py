"""Packaging settings."""


from codecs import open
from os.path import abspath, dirname, join
from subprocess import call

from setuptools import Command, find_packages, setup

from indiek.cli import __version__


this_dir = abspath(dirname(__file__))
with open(join(this_dir, 'README.rst'), encoding='utf-8') as file:
    long_description = file.read()


class RunTests(Command):
    """Run all tests."""
    description = 'run tests'
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        """Run all tests!"""
        errno = call(['py.test', '--cov=indiek.cli', '--cov-report=term-missing'])
        raise SystemExit(errno)


setup(
    name = 'indiek.cli',
    version = __version__,
    description = 'First IndieK CLI in Python.',
    long_description = long_description,
    url = 'https://github.com/indiek/indiek.cli',
    author = 'Adrian Radillo',
    author_email = 'adrian.radillo@gmail.com',
    license = 'GNU Affero General Public License v3.0',
    classifiers = [
        'Natural Language :: English',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3.6',
    ],
    keywords = 'cli',
    packages = find_packages(exclude=['docs', 'tests*']),
    install_requires = ['docopt'],
    extras_require = {
        'test': ['coverage', 'pytest', 'pytest-cov'],
    },
    entry_points = {
        'console_scripts': [
            'ik=indiek.cli.cli:main',
        ],
    },
    cmdclass = {'test': RunTests},
)
