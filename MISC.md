### STM32duino

- /etc/udev/rules.d/45-maple.rules
```
ATTRS{idProduct}=="1001", ATTRS{idVendor}=="0110", MODE="664", GROUP="dialout"
ATTRS{idProduct}=="1002", ATTRS{idVendor}=="0110", MODE="664", GROUP="dialout"
ATTRS{idProduct}=="0003", ATTRS{idVendor}=="1eaf", MODE="664", GROUP="dialout" SYMLINK+="maple"
ATTRS{idProduct}=="0004", ATTRS{idVendor}=="1eaf", MODE="664", GROUP="dialout" SYMLINK+="maple"
```
