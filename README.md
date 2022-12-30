# little-car

This is the final porject for CS207 Digital Logic
Authors: Yunxiang Yan, Zixu Huang

## 1. Project Timeline
Mid-DDL: **12.15** Final DDL: **1.8**

- [x] Play with demo
- [x] Demand Analysis
- [x] Functionality Design
- [x] Structure Design
- [x] Coding: Global State (20%)
- [x] Coding: Manual Driving (50%)
- [ ] Coding: Semi-Auto Driving (30%)
- [ ] Bonus: Auto Driving (+20%)
- [ ] Bonus: VGA (+20%)
- [ ] Report
- [ ] Demo video

## 2. Demand Analysis

### (1) Basic
- Power-on and Power-off (button)
- Throttle (switch)
- Clutch (switch)
- Brake (switch) : If we turn on brake and throttle at the same time, brake should work and throttle should not work
- Reverse gear shift (switch) : When switching this switch, the clutch must keep turning on
- Turn left and turn right (button) : If no one is pressed or both are pressed, the car should go straight.
- Car Operation (to UART)
- Turn Light (LED)
- Mileage record (7 seg) : the mileage should reset to 0 when power-off
### (2) Advanced - Semi-Auto Driving (30%)

- 3 states: moving, turning, wait-for-command
- the car is in moving state initially
- when a fork is detected by the four detectors, switch to wait-for-command
- we can send a command from: straight, left and right
- **the command buttons are inactive in moving/turning state**
- **turning state should automatically switch into moving staten when the car turns 90 degrees**

---
- use **time** to estimate 90 degrees, provide a 50Hz clk
- add a cooldown between turning and going straight, cuz the car takes a short time to calibrate the orientation
- **the value of 4 detectors may not change at the same time (time difference of about 40ms)**  

### (3) Bonus
