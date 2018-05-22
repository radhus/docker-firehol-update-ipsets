Docker image to download and update most recent FireHOL IP list

Background
----------

FireHOL update-ipsets is a great script to download and update most recent iplist of internet attackers.

http://iplists.firehol.org/

This docker image can run update-ipsets and apply the ipset.

Usage
-----

First, lets download and start a firehol-update-ipsets container.

Lets enable the ipsets. For example, we enable protection by firehol_level2 and tor_exits iplist.

```
$ docker volume create firehol-update-upsets
$ docker run --rm -it -v firehol-update-ipsets:/etc/firehol/ipsets radhus/update-ipsets enable firehol_level2 tor_exits
```

To synchronize, schedule running:
```
$ docker run --rm -it -v firehol-update-ipsets:/etc/firehol/ipsets --cap-add=NET_ADMIN --net=host radhus/update-ipsets -s
```

Above command will apply the ipset to iptables automatically, so be careful when you enable the ipset which contains private IPs (e.g. firehol_level1).
You will be locked out from the server if such ipset is enabled.
You can find the iplist contains private IPs from the following URL:

http://iplists.firehol.org/?ipset=iblocklist_iana_private

Lets check that the ipset applied to the kernel correctly.

```
$ sudo ipset list -t
$ sudo iptables-save
```

Written by
----------

Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

Distributed under MIT license.
