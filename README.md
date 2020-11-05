# 50.002-ALU-Checkoff-1

## Overview
Using the Alchitry Au FPGA, our team has implemented a 16-bit ALU which contains the following 5 modules: 
- Full Adder
- Multiplier
- Comparator
- Boolean
- Shifter

Using these modules, our ALU can perform 19 distinct operations, such as addition, subtraction, multiplication, logical operations and bit shifting. Our ALU is also able to catch and handle errors, such as invalid ALUFNs and incorrect output. 

Our ALU includes 3 testing modes: manual testing, auto testing and error checking. Details on each mode and the way to switch between modes will be explained in the following sections.

## Switching Between Modes
Upon starting or resetting, the ALU will begin in the manual testing mode. To switch to each mode, use:
- io_button[1]: Auto tester mode
- io_button[2]: Error checking mode
- io_button[3]: Manual input mode

## Manual Testing Mode
In the manual testing mode, users can enter 2 16-bit input values,A and B, as well as a 6-bit ALUFN code. Input is done using the dip switches on the FPGA, io_dip[1:0]. All 16 switches are used for A and B, while the rightmost 6 switches are used to enter ALUFN. These are the steps for using the manual testing mode:
1. Begin at state ENTER_A: flip the switches io_dip[1:0] to enter your input for A and press io_button[0]
2. Moved to state ENTER_B: flip the switches io_dip[1:0] to enter your input for B and press io_button[0]
3. Moved to state ENTER_ALUFN: flip the switcehs io_dip[0][5:0] to enter your input for ALUFN and press io_button[0]
4. At this point, the correct output will be displayed on io_led[1:0]. Note that while there is a constant output on these 16 LEDs, the output is only meaningful after entering all three values for A, B and ALUFN. The rightmost seven segment will also indicate which ALU module is currently being used (A: adder/multiplier, b: Boolean, C: comparator, S: shifter) 
5. To enter a new set of values for A, B and ALUFN, simply repeat steps 1-4.

The input handler of the manual testing mode is implemented with a finite state machine (fsm). io_led[2][1:0] is used to indicate the current state of the fsm. The following states correspond to the following outputs:
- ENTER_A: 01
- ENTER_B: 10
- ENTER_ALUFN: 11

Note that if an invalid ALUFN is entered, the seven segments will display 'Err' to indicate that there has been an error.

## Auto Testing Mode
### Input Values
In the auto testing mode, 6 pairs of A and B input values are stored as constants in the auto_tester module. During the auto testing process, an fsm cycles through the pairs of A and B values, and for each pair, a second fsm cycles through the 19 valid and 1 invalid ALUFN signals according to a slowed clock cycle. 

### Output
For the auto testing mode, there are a number of key output dispalyed on the FPGA. These are:
- io_led[1:0]: actual output from passing the values of A, B and ALUFN through the ALU modules
- io_led[2][1:0]: indicator for whether the actual output from the ALU matches the predefined expected output for each test case. io_led[2][0] lights up when there is a match while io_led[2][1] lights up when there isn't. 
- io_led[2][7:2]: current ALUFN
- seg.values[3] (rightmost seven segment): current pair of A and B being tested (ranges from 1-6)
- seg.values[0] (leftmost seven segment): current ALU module being used (A: adder/multiplier, b: Boolean, C: comparator, S: shifter)
- seg.values[2:0] (3 leftmost seven segments): shows 'Err' when an invalid ALUFN is entered

### Error Handling
The auto tester catches and handles two types of errors. First, it indicates that an invalid ALUFN has been entered by displaying 'Err' on the seven segments. Second, when the output from the ALU does not match the expected output, io_led[2][1] will light up. 

The incorrect output error case was simulated on the auto tester by selecting 5 specific combinations of A, B and ALUFN from our test cases and specially tweaking the output from the ALU. Note that this adjustment does not affect the correctness of the results from the manual testing mode, even if the same combination of A, B and ALUFN is entered there. For more details on the actual test cases used to simulate these errors, please refer to the "Test Cases" section below. 

## Error checking mode
In the error checking mode, io_led[1:0] will display the output from the ALU that was obtained from the most recent set of inputs A, B and ALUFN, from either manual or auto testing. 'Err' will be displayed on the seven segments until the input from io_dip[2:1] matches the displayed output.

The purpose of this mode is to allow us to check that the ALU is producing the correct output for a given input. This function allows us to either manually or use a second source to calculate the expected output for a given set of input, and check it against the output from the ALU to identify whether the output from the ALU is correct.

Once the output matches the input from io_dip[2:1], the rightmost seven segment will display an 'E' to indicate that the ALU is currently in the error checking mode. <br><br>

# Test Cases
We will highlight the special outputs for our 6 test cases. The full list of outputs can be found below. The test cases used to simulate the "incorrect output" error for the auto tester will be marked out from the full list of test cases below. <br><br>
### CASE_1
A : 0000 0000 0000 0000 = 0
B : 0000 0000 0000 0000 = 0
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| CMPEQ/CMPLE | 1 | A-B=0, so z=0. Hence A==B and A<=B will be true	 |
|CMPLT| 0 | A-B=0. MSB of Output=0 so n=0 and since MSB of A=0 and MSB of B=-1, v=0. so A<B will be false | 
<br>

### CASE_2
A : 1111 1111 1111 1111 = -1
B : 0000 0000 0000 0001 = 1
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| ADD |0000000000000000 | There is an overflow in this case. Output is correct as -1+1=0 |
| SUB | 1111111111111110 | There is an overflow in this case. Output is correct as -1-1=-2|
| SHA |1111111111111111 | Considering last 4 bits of B, we only shift A by 1 bit to the right. Since MSB of A=1, it still shifts right by 1 bit but we pad it with 1, thus is appears the same |
| CMPLT/CMPLE | 1 | Since the output of A-B=-2, n=1 and since MSB of A, -B and Output=1, z=0, A<B and A<=B will be true |
<br>

### CASE_3
A : 1010 0101 1100 0011 = -23101
B : 1111 0000 1010 0101 = -3931
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| ADD | 1001011001101000 | There is an overflow here as the MSB of A and B is 1 |
| MUL | 1010011010101111 | The output of A*B returns a positive number > 2<sup>15</sup>-1 the upper decimal limit for signed 16 bit number. Output will only show lower 16 bits of the actual output.|
| SHA | 1111110100101110 | We only shift by 5 bits as we consider the last 4 bits of B. Since MSB of A=1, we shift A to the right by padding it with 1 on the left instead of 0 |
| CMPLT/CMPLE | 1 |For A-B, n=1 and since MSB of A=0 and MSB of -B=1, v=0.Thus A<B and A<=B will be true |
| CMPEQ | 0 |Since A-B!=0,z=0 and A==B will be false |
<br>

### CASE_4
A : 0000 0000 0001 1001 = 25
B : 0000 0000 0001 0111 = 23
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| SUB | 0000000000000010 | There is an overflow in this case. Output is correct as 25-23 = 2 |
| SHR/SHA | 0000000000000000 | We only shift by 7 bits as we consider the last 4 bits of B. Both will have same result in this case as MSB is 0, so they both pad A with 0 on the left |
| CMPLT/CMPLE| 0 | Since A-B=2, n=0 and since MSB of A=0 and MSB of -B=1, v=0. A<B and A<=B will be false |
| CMPEQ | 0 |Since A-B=2,z=0 and A==B will be false |
<br>

### CASE_5
A : 1111 1111 1111 1111 = -1
B : 1111 1111 1111 1111 = -1
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| ADD | 1111111111111110 | There is overflow in this case as MSB of A and B is 1 |
| MUL | 0000000000000001| We multiply 2 negative numbers and since output is within decimal limit of 16 bits, we would get a positive 16 bit output|
| SHL | 1000000000000000 | Maximum we can shift A right is 15 bits as we consider last 4 bits of B only |
| SHR| 0000000000000001 | Maximum we can shift A right is 15 bits as we consider last 4 bits of B only |
| SHA | 1111111111111111 | Maximum we can shift A right is 15 bits as we consider last 4 bits of B only. Since MSB of A=1, it still shifts right by 1 bit but we pad it with 1, thus is appears the same |
| CMPEQ/CMPLE | 1 | A-B=0, z=1. Thus A==B and A<=B will be true |
| CMPLT| 0 | A-B=0. MSB of Output=0 so n=0 and since MSB of A=0 and MSB of B=-1, v=0. so A<B will be false |
<br>

### CASE_6
A : 1000 0000 0000 0000 = -32768
B : 0111 1111 1111 1111 = 32767
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| SUB | 0000000000000001 | There is an overflow in this case. A-B<-2<sup>15</sup>, the lower decimal limit for signed 16 bit number. Since we can only have 16 bits of output and actual output is 17bits, MSB of Output is 0 when in fact it should be 1 |
| MUL | 1000000000000000 | Multiplier goes out of range as A*B<-2<sup>15</sup>, the lower decimal limit for signed 16bit number. Output only show lower 16 bits of the actual output |
| SHL | 0000000000000000 | Maximum we can shift A right is 15 bits as we consider last 4 bits of B only |
| SHR | 0000000000000001| Maximum we can shift A right is 15 bits as we consider last 4 bits of B only |
| SHA | 1111111111111111 |Maximum we can shift A right is 15 bits as we consider last 4 bits of B only. Since MSB of A=1, it still shifts right by 1 bit but we pad it with 1, thus is appears as all 1s |
| CMPLT | 1 | For A-B, MSB of A,-B =1 whereas MSB of Output = 0, so v =1 while n=0. So A<B and A<=B will both be true |
<br>

# Full Test Case 
The test cases used to simulate the "incorrect output" error in the auto tester are marked with a * in their respective ALUFN/Output tables.<br><br>
### CASE_1
A : 0000 0000 0000 0000 = 0
B : 0000 0000 0000 0000 = 0
|ALUFN|OUTPUT  |
|--|--|
|ADD |0000 0000 0000 0000
|SUB |0000 0000 0000 0000
|MUL |0000 0000 0000 0000
|A   |0000 0000 0000 0000
|XOR |0000 0000 0000 0000
|OR  |0000 0000 0000 0000
|AND |0000 0000 0000 0000
|!A  |1111 1111 1111 1111
|B   |0000 0000 0000 0000
|!B  |1111 1111 1111 1111
|NAND|1111 1111 1111 1111
|NOR |1111 1111 1111 1111
|NXOR|1111 1111 1111 1111
|SHL |0000 0000 0000 0000
|SHR |0000 0000 0000 0000
|SHA |0000 0000 0000 0000
|CMPEQ |0000 0000 0000 0001
|CMPLT |0000 0000 0000 0000
|CMPLE |0000 0000 0000 0001
<br>

### CASE_2
A : 1111 1111 1111 1111 = -1
B : 0000 0000 0000 0001 = 1
|ALUFN|OUTPUT  |
|--|--|
|ADD|0000 0000 0000 0000
|SUB*|1111 1111 1111 1110
|MUL*|1111 1111 1111 1111
|A|1111 1111 1111 1111
|XOR|1111 1111 1111 1110
|OR|1111 1111 1111 1111
|AND|0000 0000 0000 0001
|!A|0000 0000 0000 0000
|B|0000 0000 0000 0001
|!B|1111 1111 1111 1110
|NAND|1111 1111 1111 1110
|NOR|0000 0000 0000 0000
|NXOR|0000 0000 0000 0001
|SHL|1111 1111 1111 1110
|SHR|0111 1111 1111 1111
|SHA|1111 1111 1111 1111
|CMPEQ|0000 0000 0000 0000
|CMPLT|0000 0000 0000 0001
|CMPLE|0000 0000 0000 0001
<br>

### CASE_3
A : 1010 0101 1100 0011 = -23101
B : 1111 0000 1010 0101 = -3931
|ALUFN|OUTPUT  |
|--|--|
|ADD|1001 0110 0110 1000
|SUB|1011 0101 0001 1110
|MUL|1010 0110 1010 1111
|A|1010 0101 1100 0011
|XOR|0101 0101 0110 0110
|OR|1111 0101 1110 0111
|AND|1010 0000 1000 0001
|!A|0101 1010 0011 1100
|B|1111 0000 1010 0101
|!B|0000 1111 0101 1010
|NAND|0101 1111 0111 1110
|NOR|0000 1010 0001 1000
|NXOR|1010 1010 1001 1001
|SHL|1011 1000 0110 0000
|SHR|0000 0101 0010 1110
|SHA|1111 1101 0010 1110
|CMPEQ|0000 0000 0000 0000
|CMPLT|0000 0000 0000 0001
|CMPLE*|0000 0000 0000 0001
<br>

### CASE_4
A : 0000 0000 0001 1001 = 25
B : 0000 0000 0001 0111 = 23
|ALUFN|OUTPUT  |
|--|--|
|ADD|0000 0000 0011 0000
|SUB|0000 0000 0000 0010
|MUL|0000 0010 0011 1111
|A|0000 0000 0001 1001
|XOR|0000 0000 0000 1110
|OR|0000 0000 0001 1111
|AND|0000 0000 0001 0001
|!A|1111 1111 1110 0110
|B|0000 0000 0001 0111
|!B|1111 1111 1110 1000
|NAND|1111 1111 1110 1110
|NOR|1111 1111 1110 0000
|NXOR*|1111 1111 1111 0001
|SHL|0000 1100 1000 0000
|SHR|0000 0000 0000 0000
|SHA|0000 0000 0000 0000
|CMPEQ|0000 0000 0000 0000
|CMPLT|0000 0000 0000 0000
|CMPLE|0000 0000 0000 0000
<br>

### CASE_5
A : 1111 1111 1111 1111 = -1
B : 1111 1111 1111 1111 = -1
|ALUFN|OUTPUT  |
|--|--|
|ADD|1111 1111 1111 1110
|SUB|0000 0000 0000 0000
|MUL|0000 0000 0000 0001
|A|1111 1111 1111 1111
|XOR|0000 0000 0000 0000
|OR|1111 1111 1111 1111
|AND|1111 1111 1111 1111
|!A|0000 0000 0000 0000
|B|1111 1111 1111 1111
|!B|0000 0000 0000 0000
|NAND|0000 0000 0000 0000
|NOR|0000 0000 0000 0000
|NXOR|1111 1111 1111 1111
|SHL*|0000 0000 0000 0000
|SHR|0000 0000 0000 0001
|SHA|1111 1111 1111 1111
|CMPEQ|0000 0000 0000 0001
|CMPLT|0000 0000 0000 0000
|CMPLE|0000 0000 0000 0001
<br>

### CASE_6
A : 1000 0000 0000 0000 = -32768
B : 0111 1111 1111 1111 = 32767
|ALUFN|OUTPUT  |
|--|--|
|ADD|1111 1111 1111 1111
|SUB|0000 0000 0000 0001
|MUL|1000 0000 0000 0000
|A|1000 0000 0000 0000
|XOR|1111 1111 1111 1111
|OR|1111 1111 1111 1111
|AND|0000 0000 0000 0000
|!A|0111 1111 1111 1111
|B|0111 1111 1111 1111
|!B|1000 0000 0000 0000
|NAND|1111 1111 1111 1111
|NOR|0000 0000 0000 0000
|NXOR|0000 0000 0000 0000
|SHL|0000 0000 0000 0000
|SHR|0000 0000 0000 0001
|SHA|1111 1111 1111 1111
|CMPEQ|0000 0000 0000 0000
|CMPLT|0000 0000 0000 0001
|CMPLE|0000 0000 0000 0001
