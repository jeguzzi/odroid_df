#!/usr/bin/env bash

alias core='docker run -it  --rm --privileged --net=host -v=/home/odroid/docker/odroid_df/odroid_manet:/home/root/catkin_ws/src/odroid_manet jeguzzi/odroid_ros roslaunch odroid_manet main.launch remote_address:=10.42.43.1'

alias it='docker run -it  --rm --privileged --net=host -v=/home/odroid/docker/odroid_df/odroid_manet:/home/root/catkin_ws/src/odroid_manet jeguzzi/odroid_ros'


