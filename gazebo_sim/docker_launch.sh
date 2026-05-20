#!/bin/bash
# Launch Gazebo Classic in Docker with GUI on Hyprland/XWayland

WORLD_DIR="$HOME/Work/St.Augustine/Robotics/gazebo_sim/worlds"

# Ensure Xauthority exists and has an entry for :1
touch "$HOME/.Xauthority"
xauth generate :1 . trusted 2>/dev/null
xhost +local: 2>/dev/null

docker run -it --rm \
  --name gazebo \
  --privileged \
  --net=host \
  -e DISPLAY=":1" \
  -e XAUTHORITY=/root/.Xauthority \
  -e QT_X11_NO_MITSHM=1 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v "$HOME/.Xauthority:/root/.Xauthority:rw" \
  -v "$HOME/Work/St.Augustine/Robotics/gazebo_sim:/gazebo_sim" \
  --device /dev/dri \
  gazebo:latest \
  gazebo --verbose /gazebo_sim/worlds/drain_classic.world
