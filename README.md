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


# Test Cases
We will highlight the special outputs for our 6 test cases. The full list of outputs can be found below
### CASE_1
A : 0000 0000 0000 0000 = 0
B : 0000 0000 0000 0000 = 0
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| CMPEQ/CMPLE | 1 | A-B=0, so z=0. Hence A==B and A<=B will be true	 |
|CMPLT| 0 | A-B=0. MSB of Output=0 so n=0 and since MSB of A=0 and MSB of B=-1, v=0. so A<B will be false |

### CASE_2
A : 1111 1111 1111 1111 = -1
B : 0000 0000 0000 0001 = 1
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| ADD |0000000000000000 | There is an overflow in this case. Output is correct as -1+1=0 |
| SUB | 1111111111111110 | There is an overflow in this case. Output is correct as -1-1=-2|
| SHA |1111111111111111 | Considering last 4 bits of B, we only shift A by 1 bit to the right. Since MSB of A=1, it still shifts right by 1 bit but we pad it with 1, thus is appears the same |
| CMPLT/CMPLE | 1 | Since the output of A-B=-2, n=1 and since MSB of A, -B and Output=1, z=0, A<B and A<=B will be true |

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

### CASE_4
A : 0000 0000 0001 1001 = 25
B : 0000 0000 0001 0111 = 23
|ALUFN  |OUTPUT  | EXPLANATION|
|--|--|--|
| SUB | 0000000000000010 | There is an overflow in this case. Output is correct as 25-23 = 2 |
| SHR/SHA | 0000000000000000 | We only shift by 7 bits as we consider the last 4 bits of B. Both will have same result in this case as MSB is 0, so they both pad A with 0 on the left |
| CMPLT/CMPLE| 0 | Since A-B=2, n=0 and since MSB of A=0 and MSB of -B=1, v=0. A<B and A<=B will be false |
| CMPEQ | 0 |Since A-B=2,z=0 and A==B will be false |

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

# Full Test Case 
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

### CASE_2
A : 1111 1111 1111 1111 = -1
B : 0000 0000 0000 0001 = 1
|ALUFN|OUTPUT  |
|--|--|
|ADD|0000 0000 0000 0000
|SUB|1111 1111 1111 1110
|MUL|1111 1111 1111 1111
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
|CMPLE|0000 0000 0000 0001

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
|NXOR|1111 1111 1111 0001
|SHL|0000 1100 1000 0000
|SHR|0000 0000 0000 0000
|SHA|0000 0000 0000 0000
|CMPEQ|0000 0000 0000 0000
|CMPLT|0000 0000 0000 0000
|CMPLE|0000 0000 0000 0000

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
|SHL|0000 0000 0000 0000
|SHR|0000 0000 0000 0001
|SHA|1111 1111 1111 1111
|CMPEQ|0000 0000 0000 0001
|CMPLT|0000 0000 0000 0000
|CMPLE|0000 0000 0000 0001

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
