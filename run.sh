#! /bin/bash

qemu-system-x86_64 \
  -m 512M \
  -nographic \
  --enable-kvm
