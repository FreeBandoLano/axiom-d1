#!/bin/bash
# ============================================================
# AXIOM D1 — Gazebo Simulation Launcher
# ============================================================
# Usage:
#   ./launch.sh              Launch the drain cleaning world
#   ./launch.sh teleop       Launch world + print teleop instructions
#
# Teleop (in a separate terminal):
#   gazebo.gz topic -t /cmd_vel -m gz.msgs.Twist \
#     -p 'linear:{x:0.15}, angular:{z:0.0}'
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set model path so Gazebo can find our custom models
export GZ_SIM_RESOURCE_PATH="${SCRIPT_DIR}/models:${GZ_SIM_RESOURCE_PATH}"

echo "============================================"
echo "  AXIOM D1 — Drain Cleaning Simulation"
echo "  Team Code Blooded | SDG 6"
echo "============================================"
echo ""
echo "Model path: ${SCRIPT_DIR}/models"
echo "World file: ${SCRIPT_DIR}/worlds/drain_cleaning.sdf"
echo ""

if [ "$1" = "teleop" ]; then
    echo "=== TELEOP COMMANDS (run in a separate terminal) ==="
    echo ""
    echo "Forward (0.15 m/s):"
    echo "  gazebo.gz topic -t /cmd_vel -m gz.msgs.Twist -p 'linear:{x:0.15}'"
    echo ""
    echo "Reverse:"
    echo "  gazebo.gz topic -t /cmd_vel -m gz.msgs.Twist -p 'linear:{x:-0.15}'"
    echo ""
    echo "Turn left:"
    echo "  gazebo.gz topic -t /cmd_vel -m gz.msgs.Twist -p 'angular:{z:0.5}'"
    echo ""
    echo "Turn right:"
    echo "  gazebo.gz topic -t /cmd_vel -m gz.msgs.Twist -p 'angular:{z:-0.5}'"
    echo ""
    echo "Stop:"
    echo "  gazebo.gz topic -t /cmd_vel -m gz.msgs.Twist -p 'linear:{x:0}, angular:{z:0}'"
    echo ""
    echo "List all sensor topics:"
    echo "  gazebo.gz topic -l"
    echo ""
    echo "Echo IMU data:"
    echo "  gazebo.gz topic -e -t /world/drain_cleaning/model/axiom_d1/link/chassis/sensor/imu/imu"
    echo ""
    echo "===================================================="
    echo ""
fi

echo "Launching Gazebo..."
gazebo.gz sim "${SCRIPT_DIR}/worlds/drain_cleaning.sdf"
