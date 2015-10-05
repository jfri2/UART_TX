# uart_tx

VHDL implementation of a UART (RS-232) transmitter.

John Fritz

UART TX

10/06/2015

This VHDL code describes a UART TX function. The objective is to interface an FPGA with a PC. The entity behaves as the DCE in the communications framework. 

Inputs:
  rst - active low async reset
	clk - clock signal
	data - 1 byte length parallel data to transmit
	send - active high. Starts transmission of data byte

Outputs:
	txd - transmission output of the uart
	cts - clear to send. Goes high to indicate uart is ready to transmit information. Remains low during transmission.
		 
Config info:
  Even parity
  1 byte wide
  1 stop bit
  Start bit sent (almost) immediately after valid send input is recieved

