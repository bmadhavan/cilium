.. _install_kvstore:

Key-Value Store
===============

+---------------------+--------------------------------------+----------------------+
| Option              | Description                          | Default              |
+---------------------+--------------------------------------+----------------------+
| --kvstore TYPE      | Key Value Store Type:                |                      |
|                     | (consul, etcd)                       |                      |
+---------------------+--------------------------------------+----------------------+
| --kvstore-opt OPTS  |                                      |                      |
+---------------------+--------------------------------------+----------------------+

consul
------

When using consul, the consul agent address needs to be provided with the
``consul.address``:

+---------------------+---------+---------------------------------------------------+
| Option              |  Type   | Description                                       |
+---------------------+---------+---------------------------------------------------+
| consul.address      | Address | Address of consul agent                           |
+---------------------+---------+---------------------------------------------------+

etcd
----

When using etcd, one of the following options need to be provided to configure the
etcd endpoints:

+---------------------+---------+---------------------------------------------------+
| Option              |  Type   | Description                                       |
+---------------------+---------+---------------------------------------------------+
| etcd.address        | Address | Address of etcd endpoint                          |
+---------------------+---------+---------------------------------------------------+
| etcd.config         | Path    | Path to an etcd configuration file.               |
+---------------------+---------+---------------------------------------------------+

Example of the etcd configuration file:

.. code:: yaml

    ---
    endpoints:
    - https://192.168.0.1:2379
    - https://192.168.0.2:2379
    ca-file: '/var/lib/cilium/etcd-ca.pem'
    # In case you want client to server authentication
    key-file: '/var/lib/cilium/etcd-client.key'
    cert-file: '/var/lib/cilium/etcd-client.crt'

