#!/bin/bash
# Capture IMU + pose data during a forward run
# Output: /gazebo_sim/sim_data_imu.txt and /gazebo_sim/sim_data_pose.txt

T="/gazebo/drain_cleaning/axiom_d1/vel_cmd"
IMU="/gazebo/drain_cleaning/axiom_d1/chassis/imu/imu"
POSE="/gazebo/drain_cleaning/pose/local/info"

echo "Resetting world..."
gz topic -p "/gazebo/drain_cleaning/world_control" -m "reset{all:true}"
sleep 2

echo "Starting data capture..."

# Capture IMU in background
timeout 14 gz topic -e "$IMU" > /gazebo_sim/sim_data_imu.txt 2>/dev/null &
IMU_PID=$!

# Capture pose in background
timeout 14 gz topic -e "$POSE" > /gazebo_sim/sim_data_pose.txt 2>/dev/null &
POSE_PID=$!

sleep 1
echo "Driving forward for 10 seconds..."

# Drive forward
for i in $(seq 1 50); do
  gz topic -p "$T" -m "position{x:0.15 y:0 z:0} orientation{x:0 y:0 z:0 w:1}"
  sleep 0.2
done

echo "Stopping robot..."
gz topic -p "$T" -m "position{x:0 y:0 z:0} orientation{x:0 y:0 z:0 w:1}"

# Wait for capture to finish
wait $IMU_PID 2>/dev/null
wait $POSE_PID 2>/dev/null

echo "Data saved to /gazebo_sim/sim_data_imu.txt and /gazebo_sim/sim_data_pose.txt"
echo "IMU lines: $(wc -l < /gazebo_sim/sim_data_imu.txt)"
echo "Pose lines: $(wc -l < /gazebo_sim/sim_data_pose.txt)"
