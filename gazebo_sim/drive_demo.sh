#!/bin/bash
# ============================================================
# AXIOM D1 — Drive Demo Script (Gazebo Classic)
#
# Usage: With the simulation running, open a second terminal:
#   docker exec -it gazebo bash /gazebo_sim/drive_demo.sh
#
# This drives the robot through the drain channel, pushing
# into debris objects to demonstrate collection capability.
# ============================================================

# List available topics to find the right one
echo "=== Available topics ==="
gz topic -l 2>/dev/null | grep -i "vel\|cmd\|drive" | head -10
echo ""

echo "=== AXIOM D1 Drive Demo ==="
echo "Starting in 3 seconds... Position your camera now!"
sleep 3

# The DiffDrivePlugin listens on ~/vel_cmd with Pose messages
# x = linear velocity, yaw (z rotation) = angular velocity

echo "[1/7] Forward — approaching debris (4s)..."
for i in $(seq 1 8); do
  gz topic -t "/gazebo/default/axiom_d1/vel_cmd" \
    -m gazebo.msgs.Pose \
    -p "position {x: 0.15} orientation {x: 0 y: 0 z: 0 w: 1}"
  sleep 0.5
done

echo "[2/7] Slight left correction (1.5s)..."
for i in $(seq 1 3); do
  gz topic -t "/gazebo/default/axiom_d1/vel_cmd" \
    -m gazebo.msgs.Pose \
    -p "position {x: 0.10} orientation {x: 0 y: 0 z: 0.2 w: 1}"
  sleep 0.5
done

echo "[3/7] Forward — pushing through debris (5s)..."
for i in $(seq 1 10); do
  gz topic -t "/gazebo/default/axiom_d1/vel_cmd" \
    -m gazebo.msgs.Pose \
    -p "position {x: 0.20} orientation {x: 0 y: 0 z: 0 w: 1}"
  sleep 0.5
done

echo "[4/7] Slight right correction (1.5s)..."
for i in $(seq 1 3); do
  gz topic -t "/gazebo/default/axiom_d1/vel_cmd" \
    -m gazebo.msgs.Pose \
    -p "position {x: 0.10} orientation {x: 0 y: 0 z: -0.2 w: 1}"
  sleep 0.5
done

echo "[5/7] Forward — continuing through drain (5s)..."
for i in $(seq 1 10); do
  gz topic -t "/gazebo/default/axiom_d1/vel_cmd" \
    -m gazebo.msgs.Pose \
    -p "position {x: 0.20} orientation {x: 0 y: 0 z: 0 w: 1}"
  sleep 0.5
done

echo "[6/7] Pivot turn demonstration (3s)..."
for i in $(seq 1 6); do
  gz topic -t "/gazebo/default/axiom_d1/vel_cmd" \
    -m gazebo.msgs.Pose \
    -p "position {x: 0.0} orientation {x: 0 y: 0 z: 0.5 w: 1}"
  sleep 0.5
done

echo "[7/7] Stopping..."
gz topic -t "/gazebo/default/axiom_d1/vel_cmd" \
  -m gazebo.msgs.Pose \
  -p "position {x: 0} orientation {x: 0 y: 0 z: 0 w: 1}"

echo ""
echo "=== Demo complete (~20s) ==="
echo "Stop your screen recording now."
