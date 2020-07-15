Project to create a working DEB package for BABELD to use on EdgeMax RouterX  (firmware v 1.x only)

Tested on
- Edgerotuer X 

# Usage

## To Install

- Copy deb file over to device
- SSH into the device
- install deb using `sudo dpkg -i <file.deb>`

## Presist across firmware upgrades

- Install post-install script (source: https://github.com/britannic/install-edgeos-packages)

```
cat <<"EOF"> install-pkgs
#!/usr/bin/env bash
# UniFi Security Gateways and EdgeOS Package Updater
# This script checks /config/data/install-packages/ for downloaded
# packages and installs any that aren't installed
#
# Author: Neil Beadle


downloads=/config/data/install-packages

cd $downloads

for pkg in *; do
  dpkg-query -W --showformat='${Status}\n' \
  $(dpkg --info "${pkg}" | \
  grep "Package: " | \
  awk -F' ' '{ print $NF}') > /dev/null 2>&1 || dpkg -i ${pkg}
done

cd -
EOF

sudo install -o root -g root -m 0755 install-pkgs /config/scripts/post-config.d/install-pkgs
rm -rf install-pkgs
sudo mkdir  -p /config/data/install-packages
```

- Copy deb package into folder
`sudo cp <file.deb> /config/data/install-packages`

## TODO

- [x] Create basic VyOS config 
- [x] Create init.d files
- [x] Package into working DEB
- [x] Presist across firmware upgrade
- [ ] Presist config across upgrades

## Configs added
    - denydefault
    - denydefaultlocal
    - interface
    - allow-duplicates
    - debug
    - diversity-factor
    - export-table
    - first-rule-priority
    - first-table-number
    - import-table
    - interface
    - ipv6-subtrees
    - kernel-priority
    - local-path
    - local-path-readwrite
    - protocol-group
    - protocol-port
    - random-id
    - redistribute
    - reflect-kernel-metric
    - router-id
    - skip-kernel-setup
    - smoothing-half-life
    - local-port-readwrite
    - redistribute
        - interface
            - local
            
## Babeld Compile

Following will compile a binary copy of babeld 
Compiled binary exists in /root/usr/bin/babeld

```
sudo apt-get install gcc-mipsel-linux-gnu
git clone git://github.com/jech/babeld.git
cd babeld
make CC='mipsel-linux-gnu-gcc -static'
```

