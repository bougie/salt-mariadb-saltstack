=======
MariaDB
=======

Install the mariadb server.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``mariadb``
---------

Runs the state to install mariadb and configure the common files.

``mariadb.install``
-----------------

Install mariadb server

``mariadb.config``
----------------

Manage the mariadb server configuration file.

``mariadb.service``
-----------------

Manage the startup and running state of the mariadb server.

``mariadb.users``
---------------

Manage mariadb users and their databases associated

``mariadb.databases``
-------------------

Manage mariadb databases and acess rights for users
