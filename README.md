# 50.002-ALU-Checkoff-1
## HOW TO RUN THE ALU ON FPGA 

io_button[0] : switches between state ENTER_A, ENTER_B, ENTER_ALUFN <br />
io_button[1] : Auto tester mode, switches between all valid ALUFN signals <br /> 
io_button[2] : Error checking mode, carried out after inputting A and B inputs, and ALUFN_SIGNALS <br />
io_button[3] : Manual tester mode <br />
io_led[0], io_led[1] : Outputs for io_led <br />
io_led[2][7:2] : alufn_signal input <br />
io_led[2][1:0] : state display for ENTER_A(b01), ENTER_B(b10), ENTER_ALUFN(b11) <br />


## Manual testing mode
 1) ALU will start in Manual Testing mode. <br />
1.1) In Manual Testing mode, it will start at state ENTER_A, represented by the lights on io_led[2][1:0], enter a[16] inputs using io_dip[0] and io_dip[1], press io_button[0] 
to move to enter b[16] <br />
1.2) Enter b[16] and proceed as in step 1.1) <br />
1.3) Enter alufn[6] and proceed as in step 1.1) <br />
1.4) Output will show on io_led[0] and io_led[1] as per a[16],b[16] and alufn[6] inputs <br />


## Auto tester mode
2) ALU is in auto tester mode <br />
2.1) Values of a[16] and b[16] are stored as inputs for auto tester mode <br />
2.2) FPGA will cycle through all valid (and 1 invalid) alufn signal, and display outputs on io_led[0] and io_led[1] <br />


## Error checking mode
3) ALU is in Error checking mode <br />
3.1) ALU will display ERR on 7segment display, until a correct input on io_dip[1] and io_dip[2] matches output of ALU operation <br />
3.2) io_dip[1] : out[7:0] , io_dip[2] : out[15:8] <br />
