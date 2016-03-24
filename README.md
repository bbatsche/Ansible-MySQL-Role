Ansible Install MySQL Role
==========================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-MySQL-Install-Role.svg?branch=master)](https://travis-ci.org/bbatsche/Ansible-MySQL-Install-Role)
[![Ansible Galaxy](https://img.shields.io/ansible/role/6893.svg)](https://galaxy.ansible.com/detail#/role/6893)

This role will install and secure a basic MySQL server

Role Variables
--------------

- `db_admin` &mdash; Admin username to be created. Default: "vagrant"
- `db_pass` &mdash; Password for admin user to be created. Default "vagrant"
- `env_name` &mdash; Whether this sever is going to be used for "development", "production", etc. Default "dev"

Example Playbook
----------------

```yml
- hosts: servers
  roles:
     - { role: bbatsche.MySQL-Install }
```

License
-------

MIT

Testing
-------

Included with this role is a set of specs for testing each task individually or as a whole. To run these tests you will first need to have [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed. The spec files are written using [Serverspec](http://serverspec.org/) so you will need Ruby and [Bundler](http://bundler.io/). _**Note:** To keep things nicely encapsulated, everything is run through `rake`, including Vagrant itself. Because of this, your version of bundler must match Vagrant's version requirements. As of this writing (Vagrant version 1.8.1) that means your version of bundler must be between 1.5.2 and 1.10.6._

To run the full suite of specs:

```bash
$ gem install bundler -v 1.10.6
$ bundle install
$ rake
```

To see the available rake tasks (and specs):

```bash
$ rake -T
```

There are several rake tasks for interacting with the test environment, including:

- `rake vagrant:up` &mdash; Boot the test environment (_**Note:** This will **not** run any provisioning tasks._)
- `rake vagrant:provision` &mdash; Provision the test environment
- `rake vagrant:destroy` &mdash; Destroy the test environment
- `rake vagrant[cmd]` &mdash; Run some arbitrary Vagrant command in the test environment. For example, to log in to the test environment run: `rake vagrant[ssh]`

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency can be tested independently as a form of integration testing.
