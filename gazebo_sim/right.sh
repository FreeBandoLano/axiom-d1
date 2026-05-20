#!/bin/bash
T=/gazebo/drain_cleaning/axiom_d1/vel_cmd
for i in $(seq 1 15); do
gz topic -p "$T" -m "position{x:0.1 y:0 z:0} orientation{x:0 y:0 z:-0.3 w:1}"
sleep 0.3
done
