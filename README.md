# 8chipsimulator
8 bit computer simulator

to build run 
```
npm install
npm install browserify -g
```
`tsc`
`browserify main.js -o output.js`

to run tests run:
`./node_modules/mocha/bin/mocha`

to run build, browserify and test - run

`npm run build`

### TODO...
* ClockView with button for clockmode, clock step, speed (mirror physical design)
* GraphView part which can graph all values of input to a register etc - useful for visual debugging directly in application.
* Revist simulator update mechanism, should use a scheduler of tasks which are generated via other tasks, as opposed to running everything every time step in topological order.
*  finish connecting modules of computer
* implement flags register and microcode
* use a nBuffer to show all control signals / or groups of signals.
* interface for wire connections/part addition.
