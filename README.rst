.. role:: bash(code)
   :language: bash
   
============
Installation
============
I use the following within an activated :bash:`conda` environment: 


.. highlight:: bash

::

    $ pip install /full/path/to/indiek.cli

For development, after any change is brought to :bash:`indiek.cli/indiek/cli/`
the `pip install` command above must be rerun.

To uninstall?

=====
Tests
=====
::

    $ python -m unittest -v tests.test_cli

and
::

    $ python -m unittest -v tests.commands.test_hello
