Description
===========
This cookbook is for setup and run scalarizr proxy-gate server. Such server is needed for organize message routing to private clouds networks.

Servers from inner network can send messages to outer Scalr server through this proxy server at port `80`. And Scalr server can access inner servers by setting `receiver-addr` header in request with targets IP. This messages are listened on `8008`, `8010` and `8013` ports.

It uses nginx for defining routing rules.

Attributes
==========
* `default['scalarizr_proxy']['scalr_addr']` -- addres of scalr server, including protocol.
* `default['scalarizr_proxy']['whitelist']` -- list of addresses that can have access to internal network (IPs of Scalr servers).

Usage
=====
You need to set proper attributes and then run default recipe.
