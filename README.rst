.. role:: bash(code)
   :language: bash
   
============
Installation
============
To install the bare package, 
I use the following within an activated :bash:`conda` environment: 


.. highlight:: bash

::

    $ pip install /full/path/to/indiek.cli

For development, after any change is brought to :bash:`indiek.cli/indiek/cli/`
the `pip install` command above must be rerun.

To install the package together with its test utilities, type the following 
instead of the above, from the top level of this repo:

::

    $ pip install -e .[test]

=====
Tests
=====
To run the full test suite, type the following from the top level of this repo:

::

    $ python setup.py test

To only run a specific test, type:
::

    $ python -m unittest -v tests.test_cli

or

::

    $ python -m unittest -v tests.commands.test_hello
