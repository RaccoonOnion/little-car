
# Little Car Project

This repository contains the final project for CS207 Digital Logic, developed by Yunxiang Yan and Zixu Huang.

## Project Timeline

- **Mid-Deadline:** December 15
- **Final Deadline:** January 8

### Milestones:

- Play with demo
- Demand Analysis
- Functionality Design
- Structure Design
- Coding:
  - Global State (20%)
  - Manual Driving (50%)
  - Semi-Auto Driving (30%)
- Report
- Demo video

## Demand Analysis

### Basic Features:

- **Power-on and Power-off:** Controlled via a button.
- **Throttle:** Operated by a switch.
- **Clutch:** Operated by a switch.
- **Brake:** Operated by a switch. If both brake and throttle are activated simultaneously, the brake takes precedence.
- **Reverse Gear Shift:** Controlled by a switch. Activation requires the clutch to be engaged.
- **Steering:**
  - **Turn Left and Turn Right:** Controlled by buttons. If neither or both buttons are pressed, the car moves straight.
- **Car Operation Output:** Data sent to UART.
- **Turn Indicators:** Represented by LEDs.
- **Mileage Record:** Displayed on a 7-segment display. Resets to 0 when powered off.

## Repository Contents

- `source/`: Contains the source code for the project.
- `.gitignore`: Specifies files and directories to be ignored by Git.
- `EGo1_user_manual.pdf`: User manual for the EGo1 platform.
- `LICENSE`: The MIT License for this project.
- `README.md`: This file.
- `Report.pdf`: Detailed project report.
- `code.zip`: Compressed archive of the source code.
- `submit.sh`: Script for submitting the project.

## Getting Started

To get a local copy up and running, follow these steps:

```bash
git clone https://github.com/RaccoonOnion/little-car.git
cd little-car
unzip code.zip -d source
```

Refer to the `EGo1_user_manual.pdf` for instructions on building and programming the project onto the hardware.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
