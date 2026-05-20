# AXIOM D1

> A compact tracked amphibious robot for cleaning shallow urban drainage channels.

![Competition](https://img.shields.io/badge/UWIRS%20%C3%97%20ESS-Robotics%20Design%20Competition-0a7?style=flat-square)
![SDG 6](https://img.shields.io/badge/UN%20SDG%206-Clean%20Water%20%26%20Sanitation-1f9?style=flat-square)
![Stage 1](https://img.shields.io/badge/Proposal%20Stage-91%2F100-success?style=flat-square)
![Simulation](https://img.shields.io/badge/Gazebo-Classic%2011.15.1-orange?style=flat-square)

![AXIOM D1 inside the drain channel](Axiom%201%20Media/Contact.png)

*AXIOM D1 (orange) operating inside the simulated concrete U-channel — debris objects and an algae patch ahead.*

---

## Overview

**AXIOM D1** is a remotely operated, tracked robot designed to clean shallow urban
drainage channels — collecting solid debris and scrubbing algae biofilm from drain
floors and walls. It was developed by team **Code Blooded** for the **UWIRS × ESS
Robotics Design Competition**, addressing **UN Sustainable Development Goal 6
(Clean Water & Sanitation)**.

Clogged drains are a recurring cause of urban flooding in Trinidad and Tobago.
Manual clearing is slow (~50–100 m per worker per day), hazardous, and exposes
workers directly to contaminated runoff. AXIOM D1 performs the same task remotely,
covering an estimated **~600 m per battery charge** at a fraction of the cost and
with no direct hazard exposure.

The project reached a proposal score of **91/100** at Stage 1, and the design was
validated in a physics-based **Gazebo simulation** before fabrication.

## Demo

A teleoperated traversal of the full drain channel is recorded in
[`Axiom 1 Media/axiom_demo.mp4`](Axiom%201%20Media/axiom_demo.mp4).

| | |
|---|---|
| ![Forward traversal](Axiom%201%20Media/forward_traversal.png) | ![Channel traversal — wide view](Axiom%201%20Media/Traversal.png) |
| Forward traverse along the U-channel | Wide view of the 10 m channel |
| ![Robot chassis — top view](Axiom%201%20Media/screenshot-2026-04-04_05-33-54.png) | ![Approaching debris](Axiom%201%20Media/Contact.png) |
| Top view — chassis, scoop, and sensor mast | Approaching debris (bottle + organic matter) |

## How It Works

AXIOM D1 is built from **six modular subsystems**, each independently testable:

| Subsystem | Function |
|-----------|----------|
| **Locomotion** | Rubber caterpillar tracks, differential skid-steer — reliable traction on wet, silt-covered concrete where wheels slip |
| **Collection** | Servo-actuated front scoop (0–120°) feeds a rubber conveyor belt into a 5 L mesh-drained bin |
| **Cleaning** | Two 3000 RPM rotary nylon brushes on spring-loaded arms scrub algae biofilm (9.4 m/s tip speed) |
| **Sensing** | 2× ultrasonic rangefinders, IMU, water-level sensor, and onboard camera for teleoperation and safety interlocks |
| **Control & Comms** | ESP32-CAM runs the 50 Hz control loop and serves MJPEG video + WebSocket command/telemetry over a local WiFi AP |
| **Power** | 3S2P LiPo pack on a fused, E-stop-protected 12 V bus with a 5 V regulated rail for logic |

## Robot Specifications

| Parameter | Value |
|-----------|-------|
| Dimensions | 400 × 350 × 150 mm (L × W × H) |
| Mass | 14.0 kg (15 kg design limit) |
| Chassis | 6061-T6 aluminium |
| Controller | ESP32-CAM — dual-core Xtensa LX6 @ 240 MHz |
| Drivetrain | Differential skid-steer, rubber tracks, 2× 12 V DC gear motors (200 RPM, 5 Nm) |
| Operating speed | 0.14–0.20 m/s |
| Battery | 3S2P LiPo — 11.1 V, 10 Ah, 111 Wh |
| Runtime | ~56–67 min (realistic duty cycle) |
| Sensors | 2× HC-SR04 ultrasonic, MPU6050 IMU, resistive water-level, OV2640 camera |
| Communication | WiFi 2.4 GHz — MJPEG video (HTTP) + WebSocket control/telemetry |
| Max water depth | 15 cm (IP67-rated enclosure) |
| Estimated prototype cost | ~USD $375 |

## Simulation

The design was validated in **Gazebo Classic 11.15.1** (run via Docker) before any
hardware was built. The simulation models the tracked chassis with a differential
drive plugin, IMU, and camera, operating in a 10 m concrete U-channel with shallow
water, an algae patch, and three debris objects.

| | |
|---|---|
| ![Track velocity profile](figures/track_velocity.png) | ![IMU acceleration data](figures/imu_acceleration.png) |
| **Track velocity** — reaches steady state ~0.14 m/s (93% of commanded 0.15 m/s) in ~1.5 s | **IMU acceleration** — Z-axis at 9.55 m/s² confirms correct gravity reading within 2.6% |

![Simulated sensor readings](figures/sensor_readings_table.png)

*Sensor readings captured during a straight-line traverse at 0.15 m/s commanded velocity.*

**Key findings from simulation:**

- **Velocity tracking** — steady-state 0.14 m/s, with the 7% deficit matching the
  calculated rolling resistance and hydrodynamic drag.
- **Lateral stability** — near-zero Y-axis acceleration confirms straight-line stability.
- **Differential steering** — zero-radius pivot turns execute cleanly within the
  450 mm channel width.
- **Debris traversal** — the robot cleared all three debris objects without loss of traction.
- A joint-axis misalignment causing lateral oscillation was diagnosed and fixed
  *in simulation* — exactly the kind of issue that is expensive to find after fabrication.

## Repository Structure

```
.
├── gazebo_sim/              Gazebo simulation environment
│   ├── models/
│   │   ├── axiom_d1/        Robot model (SDF)
│   │   └── drain_channel/   Drain environment model (SDF)
│   ├── worlds/              World files (drain_classic.world for Gazebo Classic)
│   ├── docker_launch.sh     Launches the simulation in Docker
│   ├── teleop.sh            Interactive keyboard teleop
│   ├── fwd/rev/left/right/stop.sh   Individual movement commands
│   ├── capture_data.sh      Records IMU + pose telemetry during a run
│   └── plot_sim_data.py     Generates the velocity / IMU / sensor figures
├── figures/                 Generated simulation charts
├── Axiom 1 Media/           Screenshots and demonstration video
├── CODEBLOODED_FinalReport.pdf   Full Stage 2 design report
├── Final_Design_Draft.txt   Stage 2 working draft
├── Delano_Sections_Draft.md Detailed subsystem, design, and simulation write-up
└── Proposal_Draft.txt       Stage 1 proposal (scored 91/100)
```

## Running the Simulation

The simulation runs in Gazebo Classic 11.15.1 inside a Docker container, with
display forwarding to the host via XWayland.

```bash
# Launch Gazebo with the AXIOM D1 model in the drain world
./gazebo_sim/docker_launch.sh

# In a second terminal, attach to the container and drive the robot
docker exec -it gazebo bash
./teleop.sh        # arrow keys to drive, space to stop, R to reset, Q to quit

# Capture telemetry during a forward run, then plot it on the host
./gazebo_sim/capture_data.sh
python3 gazebo_sim/plot_sim_data.py   # requires matplotlib
```

> The Gazebo Harmonic snap (`launch.sh`, SDF 1.9 models) is included but currently
> non-functional under Hyprland/Wayland due to snap confinement — use the Docker
> path above.

## Documentation

- **[CODEBLOODED_FinalReport.pdf](CODEBLOODED_FinalReport.pdf)** — full Stage 2 design report
- **[Delano_Sections_Draft.md](Delano_Sections_Draft.md)** — detailed subsystem breakdown,
  design methodology (Pugh matrix), engineering calculations, and simulation analysis

## Team

**Code Blooded** — Delano D. Montplaisir · Deborah McDougall · Enya Cariah

Submitted for the UWIRS × ESS Robotics Design Competition.
