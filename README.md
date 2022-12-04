# little-car

This is the final porject for CS207 Digital Logic
Authors: Yunxiang Yan, Zixu Huang

## 1. Project Timeline
Mid-DDL: **12.16** Final DDL: **12.28**

- [x] Play with demo
- [ ] Demand Analysis
- [ ] Functionality Design
- [ ] Structure Design
- [ ] Verilog Coding
- [ ] Verification: module unit test, comprehensive test
- [ ] On board testing 

## 2. Demand Analysis

### (1) Basic

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
