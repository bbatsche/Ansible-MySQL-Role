Ansible Install MySQL Role
==========================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-MySQL-Install-Role.svg)](https://travis-ci.org/bbatsche/Ansible-MySQL-Install-Role)
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

Included with this role is a set of specs for testing each task individually or as a whole. To run these tests you will first need to have [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed. The spec files are written using [Serverspec](http://serverspec.org/) so you will need Ruby and [Bundler](http://bundler.io/).

To run the full suite of specs:

```bash
$ gem install bundler
$ bundle install
$ rake
```

The spec suite will target both Ubuntu Trusty Tahr (14.04) and Xenial Xerus (16.04).

To see the available rake tasks (and specs):

```bash
$ rake -T
```

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency is tested independently via integration testing.
