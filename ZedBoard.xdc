set_property IOSTANDARD LVCMOS33 [get_ports clock]
set_property PACKAGE_PIN Y9 [get_ports clock]
create_clock -period 10.000 [get_ports clock]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN T22 [get_ports {LED[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN T21 [get_ports {LED[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN U22 [get_ports {LED[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN U21 [get_ports {LED[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN V22 [get_ports {LED[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN W22 [get_ports {LED[5]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN U19 [get_ports {LED[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
set_property PACKAGE_PIN U14 [get_ports {LED[7]}]



#set_property IOSTANDARD LVCMOS33 [get_ports reset]
#set_property PACKAGE_PIN F22 [get_ports reset]

#SW7
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN M15 [get_ports reset]

## "BTNC"
#set_property IOSTANDARD LVCMOS33 [get_ports reset]
#set_property PACKAGE_PIN P16 [get_ports reset]

SW0
set_property IOSTANDARD LVCMOS33 [get_ports phaseSelect[0]]
set_property PACKAGE_PIN F22 [get_ports phaseSelect[0]]

#SW1
set_property IOSTANDARD LVCMOS33 [get_ports phaseSelect[1]]
set_property PACKAGE_PIN G22 [get_ports phaseSelect[1]]

#SW2
set_property IOSTANDARD LVCMOS33 [get_ports phaseSelect[2]]
set_property PACKAGE_PIN H22 [get_ports phaseSelect[2]]

#SW3
set_property IOSTANDARD LVCMOS33 [get_ports phaseSelect[3]]
set_property PACKAGE_PIN F21 [get_ports phaseSelect[3]]

#SW4
set_property IOSTANDARD LVCMOS33 [get_ports phaseSelect[4]]
set_property PACKAGE_PIN H19 [get_ports phaseSelect[4]]

#SW5
set_property IOSTANDARD LVCMOS33 [get_ports phaseSelect[5]]
set_property PACKAGE_PIN H18 [get_ports phaseSelect[5]]

#SW6
set_property IOSTANDARD LVCMOS33 [get_ports phaseSelect[6]]
set_property PACKAGE_PIN H17 [get_ports phaseSelect[6]]





#JA1 channel 5
set_property IOSTANDARD LVCMOS33 [get_ports {Thyristors[0]}]  
set_property PACKAGE_PIN Y11 [get_ports {Thyristors[0]}]
#JA2 channel 4
set_property IOSTANDARD LVCMOS33 [get_ports {Thyristors[1]}]
set_property PACKAGE_PIN AA11 [get_ports {Thyristors[1]}]
#JA3 channel 3
set_property IOSTANDARD LVCMOS33 [get_ports {Thyristors[2]}]
set_property PACKAGE_PIN Y10 [get_ports {Thyristors[2]}]
#JA4 channel 2
set_property IOSTANDARD LVCMOS33 [get_ports {Thyristors[3]}]
set_property PACKAGE_PIN AA9 [get_ports {Thyristors[3]}]
#JA7 channel 1
set_property IOSTANDARD LVCMOS33 [get_ports {Thyristors[4]}]
set_property PACKAGE_PIN AB11 [get_ports {Thyristors[4]}]
#JA8  channel 0
set_property IOSTANDARD LVCMOS33 [get_ports {Thyristors[5]}]
set_property PACKAGE_PIN AB10 [get_ports {Thyristors[5]}]


#JB1
set_property IOSTANDARD LVCMOS33 [get_ports SquareWave1]
set_property PACKAGE_PIN W12 [get_ports SquareWave1]
#JB2
set_property IOSTANDARD LVCMOS33 [get_ports SquareWave2]
set_property PACKAGE_PIN W11 [get_ports SquareWave2]
#JB3
set_property IOSTANDARD LVCMOS33 [get_ports SquareWave3]
set_property PACKAGE_PIN V10 [get_ports SquareWave3]
