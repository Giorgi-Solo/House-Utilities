# House-Utilities

The project objectives were to write Verilog modules that represent house utilities: 

* Digital clock displaying time in the following format: hh:mm:ss – MM/DD – MCDY.
* Door lock which unlocks if correct combination is entered.
* Dishwasher/gas_cooker which can be set to for certain amount of time – countdown is displayed on timer and 1 minute after timer reaches 0 the power is turned off. 
* Garage door which has remote control allowing the user to open and close the door or activate smart mode. In smart mode, when a car approaches the garage, the door * *  opens. The door stays open until car goes into the garage and the driver comes out of it. After the driver leaves the garage, door closes and the smart mode is disabled. 


Repository Guide

* doc - Documentation
* rtl - rtl design files
* tesbench - testbench for the top module
