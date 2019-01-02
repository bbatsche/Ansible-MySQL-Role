Ansible MySQL Role
==========================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-MySQL-Role.svg)](https://travis-ci.org/bbatsche/Ansible-MySQL-Role)
[![License](https://img.shields.io/github/license/bbatsche/Ansible-MySQL-Role.svg)](LICENSE)
[![Role Name](https://img.shields.io/ansible/role/6893.svg)](https://galaxy.ansible.com/bbatsche/MySQL)
[![Release Version](https://img.shields.io/github/tag/bbatsche/Ansible-MySQL-Role.svg)](https://galaxy.ansible.com/bbatsche/MySQL)
[![Downloads](https://img.shields.io/ansible/role/d/6893.svg)](https://galaxy.ansible.com/bbatsche/MySQL)

This role will install & configure MySQL, MariaDB, or Percona server and/or create databases & users for those servers.

Please note, only one server may be installed at any given time, and this role does not support switching from one server type to another.

Role Variables
--------------

- `db_admin` &mdash; Admin username to be created. Default is "vagrant"
- `db_pass` &mdash; Password for admin user to be created. Default is "vagrant"
- `env_name` &mdash; Whether this sever is going to be used for "development", "production", etc. Default is "dev"
- `install_mysql` &mdash; Install MySQL server. Default is no
- `install_mariadb` &mdash; Install MariaDB server. Default is no
- `install_percona` &mdash; Install Percona server. Default is no.
- `new_db_name` &mdash; Name of database to create. Default is undefined (skipped)
- `new_db_user` &mdash; Username of new user to create. Default is undefined (skipped)
- `new_db_pass` &mdash; Password of new user to create. Default is undefined (skipped)
- `new_db_priv` &mdash; Privileges to grant new user. Default is to give them full control of server, or database (if defined)
- `remove_root_user` &mdash; Remove root user during installation. Default is to remove it.
- `mysql_deb` &mdash; URL of MySQL repository to add to APT. Default is "https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb"
- `mariadb_apt_key.trusty` &mdash; APT key for installing MariaDB on Trusty Tahr. Default is "0xcbcb082a1bb943db"
- `mariadb_apt_key.xenial` &mdash; APT key for installing MariaDB on Xenial Xerus. Default is "0xF1656F24C74CD1D8"
- `mariadb_version` &mdash; Version of MariaDB to install. Default is "10.2"
- `mariadb_apt_mirror`&mdash; Mirror to download MariaDB from. Default is "http://nyc2.mirrors.digitalocean.com"
- `percona_deb` &mdash; URL of Percona server repository to add to APT. Default is "`https://repo.percona.com/apt/percona-release_0.1-4.{{ ansible_distribution_release }}_all.deb`"
- `percona_version` &mdash; Version of Percona server to install. Default is "5.7"
- `mysql_socket` &mdash; Path to MySQL socket. Default is "/var/run/mysqld/mysqld.sock"
- `mysql_enable_network` &mdash; Whether or not to listen to external network connections. Default is no
- `mysql_sql_mode` &mdash; SQL mode to use. Default is "ANSI,TRADITIONAL"
- `mysql_max_connections` &mdash; Maximum number of allowed connections. Default is "300"
- `mysql_wait_timeout` &mdash; Wait timeout. Default is "300"

### Tuning Variables

MySQL of course has many settings in order to tweak its performance and resource usage. This role supports setting or calculating a handful of the most relevant ones.

- `mysql_mem_percent` &mdash; Percentage of total memory MySQL should use. This is by no means a cap, or really enforced, it's more a target used for calculating some of the other variables. Default is "40"
- `innodb_buffer_pool_percent` &mdash; Percentage of MySQL's memory to use for the InnoDB buffer pool. Default is "90"
- `innodb_buffer_pool_size` &mdash; Amount of total memory to use for InnoDB buffer pool. Default is calculated based on `mysql_mem_percent` and `innodb_buffer_pool_percent`
- `innodb_buffer_pool_chunk_size` &mdash; InnoDB buffer pool chunk size. Default is "128M"
- `mysql_key_buffer_percent` &mdash; Percentage of MySQL's memory to use for key buffer. Default is "40"
- `mysql_key_buffer_size` &mdash; Amount of total memory to use for MySQL key buffer. Default is calculated based on `mysql_mem_percent` and `mysql_key_buffer_percent`
- `mysql_max_heap_table_size` &mdash; Max heap table size. Default is calculated based on total memory
- `mysql_open_files_limit` &mdash; Open files limit. Default is 32 per MB of total memory
- `mysql_tmp_table_size` &mdash; Temp table size. Default is calculated based on total memeory

### Password Validation Variables

This role allows you to define password validation requirements for your server. This configuration is skipped in dev environments.

- `mysql_password_policy` &mdash; MySQL password policy. Default is "MEDIUM" (ignored in MariaDB)
- `mysql_password_check_username` &mdash; Check if a user's password contains their username. Default is "OFF" (ignored in MariaDB)
- `mysql_password_length` &mdash; Password length requirements. Default is "5"
- `mysql_password_mixed_case_count` &mdash; Number of mixed case characters required. Default is "0"
- `mysql_password_number_count` &mdash; Number of digits required. Default is "0"
- `mysql_password_special_char_count` &mdash; Number of non-alphanumeric characters required. Default is "0"

### Other Tweaking Variables

- `innodb_io_capacity` &mdash; InnoDB IO capacity. Default is "400"
- `innodb_log_buffer_size` &mdash; InnoDB log buffer size. Default is "16M"
- `myisam_sort_buffer_size` &mdash; MyISAM sort buffer size. Default is "128M"
- `mysql_bulk_insert_buffer_size` &mdash; Bulk insert buffer size. Default is "16M"
- `mysql_max_allowed_packet` &mdash; Max allowed packet size. Default is "16M"
- `mysql_query_cache_type` &mdash; Whether to enable the MySQL query cache. Default is "ON"
- `mysql_query_cache_size` &mdash; Query cache size. Default is "32M" if the query cache is enabled, otherwise "0"
- `mysql_query_cache_limit` &mdash; Query size limit for cache. Default is "1M"
- `mysql_read_buffer_size` &mdash; Read buffer size. Default is "2M"
- `mysql_read_rnd_buffer_size` &mdash; Read random buffer size. Default is "2M"
- `mysql_sort_buffer_size` &mdash; Sort buffer size. Default is "2M"
- `mysql_table_open_cache` &mdash; Table open cache. Default is "2000"

Example Playbook
----------------

Install a service (MariaDB):

```yml
- hosts: servers
  roles:
     - role: bbatsche.MySQL
       install_mariadb: yes
```

Create a new user (assuming a service is already installed and running):

```yml
- hosts: servers
  roles:
     - role: bbatsche.MySQL
       new_db_user: my_new_user
       new_db_pass: n0tV3ry$ecuRe
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

The spec suite will target Ubuntu Trusty Tahr (14.04), Xenial Xerus (16.04), and Bionic Bever (18.04).

To see the available rake tasks (and specs):

```bash
$ rake -T
```

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency is tested independently via integration testing.
