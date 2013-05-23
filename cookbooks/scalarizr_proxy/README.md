Description
===========
This cookbook is for setup and run scalarizr proxy-gate server. Such server is needed for organize message routing to private clouds networks.

Servers from inner network can send messages to outer Scalr server through this proxy server at port `80`. And Scalr server can access inner servers by setting `x-receiver-host` for target ip and `x-receiver-port` for target port. By default `x-receiver-port` is one of `8009`, `8011` or `8014`.

It uses nginx for defining routing rules.

Attributes
==========
* `default['scalarizr_proxy']['scalr_addr']` -- addres of scalr server, including protocol.
* `default['scalarizr_proxy']['whitelist']` -- list of addresses that can have access to internal network (IPs of Scalr servers).

Usage
=====
You need to set proper attributes and then run default recipe.
