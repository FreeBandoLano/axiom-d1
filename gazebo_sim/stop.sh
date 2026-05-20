#!/bin/bash
T=/gazebo/drain_cleaning/axiom_d1/vel_cmd
gz topic -p "$T" -m "position{x:0 y:0 z:0} orientation{x:0 y:0 z:0 w:1}"
