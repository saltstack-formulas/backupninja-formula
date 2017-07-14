===================
backupninja-formula
===================

Configure backupninja using SaltStack Pillar.

This formula is meant to be a thin wrapper around standard backupninja configuration,
enabling us to re-use our knowledge of backupninja without wrapping our head around a
thick abstraction layer.
Therefore configuration details are not discussed here. Please see `backupninja Configuration <https://0xacab.org/riseuplabs/backupninja#configuration>`_ for an overview.

When reading ``pillar.example`` you'll probably notice that Pillar maps directly to the configuration directives described in `backupninja example files <https://0xacab.org/riseuplabs/backupninja/tree/master/examples>`_. If they don't (and there's no comment explaining why) that's probably a bug. In that case please file an issue or submit a Pull Request.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. note::

    Yes, I was aware of `salt-formulas/salt-formula-backupninja <https://github.com/salt-formulas/salt-formula-backupninja>`_
    (notice ``salt-formulas`` vs ``saltSTACK-formulas``)
    at the time I started this formula. Their formula is great, but also
    bound to their eco system of formulas. I need(ed) something decoupled, reusable,
    which used the standard SaltStack design patterns (``map.jinja`` & Co.).

.. note::

    Don't forget to add extra file references to your ``master`` file if you're using ``salt-ssh``.
    Otherwise ``macros.jinja`` & Co. won't be synced.

    .. code-block:: yaml

        extra_filerefs:
          - salt://backupninja/defaults.yaml
          - salt://backupninja/map.jinja
          - salt://backupninja/macros.jinja

Available states
================

.. contents::
    :local:

``backupninja``
---------------

Includes ``backupninja.install`` and ``backupninja.config``

``backupninja.install``
-----------------------

Installs the backupninja package(s).

``backupninja.config``
----------------------

Configures backupninja based on Pillar.
See ``pillar.example`` for details.
