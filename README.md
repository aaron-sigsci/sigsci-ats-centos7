# sigsci-module-ats
Apache Traffic Server Module for Signal Sciences

sigsci_module.so

## Installation:

Packages available for the following OS's.

centos-7 (el7): 

Package repo can be added from: https://docs.signalsciences.net/install-guides/redhat/agent/#step-1-add-the-package-repositories

* yum install sigsci-module-ats : installs lib to /usr/local/libexec/trafficserver

centos-6 (el6):

Package repo can be added from: https://docs.signalsciences.net/install-guides/redhat/agent/#step-1-add-the-package-repositories

* yum install sigsci-module-ats : installs lib to /usr/local/libexec/trafficserver

ubuntu-18.04 (bionic) :

Package repo can be added from: https://docs.signalsciences.net/install-guides/ubuntu/agent/#step-1-add-the-package-repositories

* apt-get install sigsci-module-ats : installs lib to /usr/lib/trafficserver/modules


## Configuration:

The Signal Sciences module is configured through a simple file.

---

Following is an example of the Apache Traffic Server **plugin.config** :

```
sigsci_module.so

#Optionally, Module configuration flags can be defined in a separate config file
#sigsci_module.so /etc/trafficserver/sigsci/sigsci.config
```
---

Following is an example of the **sigsci.config** file specified from **plugin.config** :

```
# true = inspection enabled
# false = inspection disabled
# default: true
sigsci_enabled true

# phase hook values: read_req_hdrs post_remap 
# default: post_remap
# NOTE: read_req_hdrs phase runs before remap phases - so although it will honor
# global inspection disabled, it will not honor the remap inspection enabled or
# disabled if set in remap.config
sigsci_handler_phase post_remap

# max post body size in bytes to send to the agent
# max allowed: 2000000
# default: 100000
max_post_len 8800

# true = use Unix Domain Socket for comm with the sigsci agent
# false = not using Unix Domain Socket - implies using tcp port
# default: true
unix_rpc true

# tcp port to comm with the sigsci agent
# Do not specify if unix_rpc is being used
# default: 0
# agent_port 9999

# unix domain socket: file path for UDS
# tcp: ip address or hostname where agent is running
# default: "/var/run/sigsci.sock"
agent_host "/home/y/var/run/sigsci.sock"

# agent response time in millis
# default: 100
agent_timeout 50

# anomalous response size in bytes
# default: 524288
anom_resp_size 4096

# anomalous response time in millis
# default: 1000
anom_resp_time 100
```

## Remap Configuration (OPTIONAL, only needed to enable/disable for specific remap paths):

Following is an example for the remap.config:

```
map / http://127.0.0.1:80/ @plugin=/usr/local/libexec/trafficserver/sigsci_module.so @pparam=enabled
reverse_map http://127.0.0.1:80/ https://127.0.0.1:8433/

# example of path where sigsci inspection is disabled
map https://127.0.0.1:8443/noinspect/ http://127.0.0.1:80/noinspect/ @plugin=/usr/local/libexec/trafficserver/sigsci_module.so @pparam=disabled
reverse_map http://127.0.0.1:80/noinspect/ https://127.0.0.1:8443/noinspect/
```

## Debug Configuration:

The module uses the tag **sigsci** to log debug statements.

Example of turning on debug in **records.config** :
```
CONFIG proxy.config.diags.debug.tags STRING sigsci
```

