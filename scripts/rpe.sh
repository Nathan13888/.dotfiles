#!/bin/bash

pkill pulseeffects
pulseeffects --gapplication-service &
disown

