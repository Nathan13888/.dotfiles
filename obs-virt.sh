#!/bin/bash

#pkill -9 obs
sudo modprobe -r v4l2loopback
sudo obs --startvirtualcam --profile VirtCam
