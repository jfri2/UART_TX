-----------------------------------------------------------------------------------
--	John Fritz
--	UART TX
--	10/06/2015
--
--	This VHDL code describes a UART TX function.
--	The objective is to interface an FPGA with a
--	PC. The entity behaves as the DCE in the comm
--	framework. 
--
--	Inputs:
--		rst - active low async reset
--		clk - clock signal
--		data - 1 byte length parallel data to transmit
--		send - active high. Starts transmission of data byte
--		
--	Outputs:
--		txd - transmission output of the uart
--		cts - clear to send. Goes high to indicate uart is ready
--				 to transmit information. Remains low during info
--				 transmission.
--		 
-- Config info:
-- UART is even parity
-- 1 byte wide
-- 1 stop bit
-----------------------------------------------------------------------------------

entity uart_tx is 
	port(rst, clk, send 	:	in bit;
			data	:	in bit_vector(7 downto 0);
			txd, cts			:	out bit);
end uart_tx;
-----------------------------------------------------------------------------------
architecture behavioral of uart_tx is
--took signals out of this because they were causing delays on start
--in a process signals update at the end while variables update in order
begin
-----------------------------------------------------------------------------------
-- main uart process	
	process(clk, rst)
		variable bit_count : integer range 0 to 11;
		variable parity_v : bit;
--if made a signal rather than a var, there will be a one clock delay to tx start
		variable tx_active : bit;
		variable data_reg : bit_vector(10 downto 0);		
	begin
		if rst = '0' then
			tx_active := '0';		
			txd <= '1';				--idle state
			cts <= '0';				--cant send during reset condition
		elsif (clk'event and clk='1') then
			if send ='1' then
			bit_count := 0;		
				--calculate parity bit
				 parity_v := '0';
				 for i in data'range loop
					 parity_v := parity_v xor data(i);
				 end loop;
				--load input data into register
				data_reg(9 downto 2) := data(7 downto 0);	--load data register
				data_reg(10) := '0';				--load start bit
				data_reg(1 downto 0) := parity_v & '1';		--load parity & stop bit
				tx_active := '1';				--set state to transmitting					
			elsif (send='0' and tx_active='0') then
				cts <= '1';
			end if;
			if tx_active = '1' then			
				cts <= '0';		--not clear to send
				txd <= data_reg(10);
				data_reg(10 downto 0) := data_reg(9 downto 0) & '1';			
				if bit_count = 11 then 	
					tx_active := '0';
					cts <= '1';
					txd <= '1';
				end if;				
				bit_count := bit_count + 1;	--increment bit_count
			end if;
		end if;
	end process;
-----------------------------------------------------------------------------------	
end behavioral;
-----------------------------------------------------------------------------------	
