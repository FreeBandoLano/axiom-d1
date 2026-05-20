# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AXIOM D1 — a compact tracked amphibious robot for cleaning shallow urban drainage channels in Trinidad and Tobago. Built for the UWIRS x ESS Robotics Design Competition (SDG 6: Clean Water and Sanitation).

**Team:** Code Blooded (Delano D. White, Deborah McDougall, Enya Cariah)

**Robot specs:** 400x350x150mm, 14 kg, 12V 10Ah LiPo, ESP32-CAM controller, differential skid-steer tracks, scoop+conveyor collection, rotary brush cleaning.

## Repository Structure

- `Proposal_Draft.txt` — Stage 1 proposal content (submitted, scored 91/100)
- `Final_Design_Draft.txt` — Full Stage 2 draft (all sections, used as reference)
- `Delano_Sections_Draft.md` — Delano's assigned sections for the Final Design Report (Sections 3, 4, 5A, 5B, 5D, 6). Includes simulation figures, sensor table, velocity graph, IMU plot, and all abbreviations expanded at first use.
- `Rubric/` — Competition templates, rubrics, reference papers, and graded feedback
- `Rubric/Finals/feedback.jpg` — Graded rubric from Stage 1 with examiner comments
- `gazebo_sim/` — Gazebo simulation environment
- `figures/` — Generated simulation charts (track_velocity.png, imu_acceleration.png, sensor_readings_table.png)
- `Axiom 1 Media/` — Screenshots, video recording (axiom_demo.mp4), and renamed images (e.g. "Forward Traversal")

## Gazebo Simulation

**Launch command:**
```bash
~/Work/St.Augustine/Robotics/gazebo_sim/docker_launch.sh
```

Gazebo runs via Docker (Gazebo Classic 11.15.1). The Gazebo Harmonic snap is installed but non-functional due to strict confinement + Hyprland/Wayland IPC isolation.

**World & model files:**
- `gazebo_sim/worlds/drain_classic.world` — SDF 1.6 world for Docker/Gazebo Classic (use this)
- `gazebo_sim/worlds/drain_cleaning.sdf` — SDF 1.9 world for Gz Sim/Harmonic snap (broken)
- `gazebo_sim/models/axiom_d1/` — Robot model (SDF 1.9 format, for snap)
- `gazebo_sim/models/drain_channel/` — Drain environment model (SDF 1.9 format, for snap)
- `gazebo_sim/docker_launch.sh` — Docker launch with XWayland display forwarding
- `gazebo_sim/launch.sh` — Snap-based launcher (does not work)

**Control scripts (run inside Docker container via `docker exec -it gazebo bash`):**
- `gazebo_sim/teleop.sh` — Interactive keyboard teleop (arrow keys, space=stop, R=reset, Q=quit)
- `gazebo_sim/fwd.sh`, `rev.sh`, `left.sh`, `right.sh`, `stop.sh` — Individual movement scripts
- Reset world: `gz topic -p "/gazebo/drain_cleaning/world_control" -m "reset{all:true}"`

**Data capture & plotting:**
- `gazebo_sim/capture_data.sh` — Captures IMU + pose data during a forward run (run inside Docker)
- `gazebo_sim/plot_sim_data.py` — Parses captured data, generates velocity graph + IMU plot + sensor table (run on host, requires matplotlib)

**Prerequisites for Docker launch:** `~/.Xauthority` must exist (script handles `xauth generate :1 . trusted`).

**Key simulation notes:**
- Track cylinders use rotation `(0, π/2, π/2)` — the revolute joint axis must be `<xyz>0 0 1</xyz>` (not `0 1 0`) to align with world-Y in the rotated child frame. Using `0 1 0` causes lateral oscillation instead of forward motion.
- DiffDrivePlugin torque is set to 12 Nm. Track radius 0.06 m, friction mu=1.5.
- Robot achieves ~0.14 m/s steady state (93% of commanded 0.15 m/s).
- Scoop/conveyor collection is NOT yet articulated — the scoop is a fixed visual on the chassis. Debris interaction is contact-only (push, not collect). Plan for articulated scoop exists in the plan file. The approach: convert scoop to a revolute joint link, add collision-walled bin, control via `gz joint` commands.

## Network / Proxy

A Shadowsocks SOCKS5 proxy is configured in `~/.bashrc` (`socks5://127.0.0.1:1080`) but is frequently not running. Always `unset http_proxy https_proxy all_proxy` before network-dependent operations (yay, docker pull, etc.).

## Key Feedback Addressed (from 91/100 rubric)

- Mobile app: fully specified in Section 3.5.2 (WPA2-PSK + session token auth, WebSocket protocol, UI layout)
- Measurement target justifications: added throughout Sections 5A-5D
- Underwater obstacle consideration: addressed in Section 5A (Sensor 1)
- Simulation validation: Section 6B with real Gazebo data (IMU, velocity profile, screenshots, video)
