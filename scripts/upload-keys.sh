#!/bin/bash

servers=(
    "hkps://pgp.mit.edu"
    "hkps://keyserver.ubuntu.com"
    "hkps://keyring.debian.org"
)

readonly keyid=${1:?"Missing KEYID"}

for server in ${servers[@]}; do
    echo -e "Sending public key to $server"
    gpg --send-keys --keyserver $server $keyid
    echo -e "\n"
done
