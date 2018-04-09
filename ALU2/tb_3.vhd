library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

--Test bench for ALU_TOP

entity TB_3 is
end TB_3;

architecture test of TB_3 is

constant N_1 : integer := 8;
constant N_2 : integer := 16;
constant N_3 : integer := 32;

signal A1: 			std_logic_vector(7 downto 0);
signal B1:  		std_logic_vector(7 downto 0);
signal OP1: 		std_logic_vector(3 downto 0);
signal clk:			std_logic;
signal valid1: 		std_logic;
signal HI1:     	std_logic_vector(7 downto 0);
signal LO1:     	std_logic_vector(7 downto 0);
signal status1: 	std_logic_vector(5 downto 0);

signal A2: 			std_logic_vector(15 downto 0);
signal B2:  		std_logic_vector(15 downto 0);
signal OP2: 		std_logic_vector(3 downto 0);
signal valid2: 		std_logic;
signal HI2:     	std_logic_vector(15 downto 0);
signal LO2:     	std_logic_vector(15 downto 0);
signal status2: 	std_logic_vector(5 downto 0);

--signal A3: 			std_logic_vector(31 downto 0);
--signal B3:  		std_logic_vector(31 downto 0);
--signal OP3: 		std_logic_vector(3 downto 0);
--signal valid3: 		std_logic;
--signal HI3:     	std_logic_vector(31 downto 0);
--signal LO3:     	std_logic_vector(31 downto 0);
--signal status3: 	std_logic_vector(5 downto 0);

begin

CLK_PROCESS: process
begin
	clk <= '0';
while (0 = 0) loop
  wait for 5 ns;
	clk <= '1';
	wait for 5 ns;
	clk <= '0';
end loop;
end process;

ALU_8: entity work.ALU_top
	generic map (N_1)
	port map(	
		A1, B1, OP1, clk, valid1, HI1, LO1, status1);
		
ALU_16: entity work.ALU_top
	generic map (N_2)
	port map(	
		A2, B2, OP2, clk, valid2, HI2, LO2, status2);
		
simulation1 : process
begin
	OP1 <= "0000";
	wait for 12 ns; 
	OP1 <= "0111"; --first op must be RST
	A1  <= X"00";
	B1	<= x"00";
	wait for 10 ns;
	ASSERT valid1 = '0'
	REPORT "Test Failed - MAC operations must be 2 cycles"
	SEVERITY error;
	wait for 10 ns;
	ASSERT valid1 = '1'
	REPORT "Test Failed - MAC Reset Failed - Valid is 0"
	SEVERITY error;
	ASSERT LO1 = X"00"
	REPORT "Test Failed - MAC Reset Failed - LO not 0"
	SEVERITY error;
	ASSERT HI1 = X"00"
	REPORT "Test Failed - MAC Reset Failed - HI not 0"
	SEVERITY error;
	OP1 <= "0001";
	for i in 0 to 7 loop
		A1(i) <= '1';
		wait for 10 ns;
		ASSERT valid1 = '1'
		REPORT "Test Failed - ADD Reset Failed - Valid is 0"
		SEVERITY error;
		ASSERT HI1 = X"00"
		REPORT "Test Failed - ADD Reset Failed - HI not 0"
		SEVERITY error;
		ASSERT LO1 = A1
		REPORT "Test Failed - ADD Reset Failed - LO != A"
		SEVERITY error;
	end loop;
	A1 <= X"00";
	for i in 0 to 7 loop
		B1(i) <= '1';
		wait for 10 ns;
		ASSERT valid1 = '1'
		REPORT "Test Failed - ADD Reset Failed - Valid is 0"
		SEVERITY error;
		ASSERT HI1 = X"00"
		REPORT "Test Failed - ADD Reset Failed - HI not 0"
		SEVERITY error;
		ASSERT LO1 = B1
		REPORT "Test Failed - ADD Reset Failed - LO != B"
		SEVERITY error;
	end loop;
	B1 <= X"00";
	for i in 0 to 7 loop
		B1(i) <= '1';
		A1(i) <= '1';
		wait for 10 ns;
		ASSERT valid1 = '1'
		REPORT "Test Failed - ADD Reset Failed - Valid is 0"
		SEVERITY error;
		ASSERT HI1 = X"00"
		REPORT "Test Failed - ADD Reset Failed - HI not 0"
		SEVERITY error;
		ASSERT LO1(0) = '0'
		REPORT "Test Failed - ADD Reset Failed - LO != A+B bit0"
		SEVERITY error;
		for j in 1 to 7  loop
			if j <= i + 1 then
				ASSERT LO1(j) = '1'
				REPORT "Test Failed - ADD Reset Failed - LO != A+B 2"
				SEVERITY error;
			else
				ASSERT LO1(j) = '0'
				REPORT "Test Failed - ADD Reset Failed - LO != A+B, j"
				SEVERITY error;
			end if;
		end loop;
	end loop;
	
	OP1 <= "0010";
	wait for 10 ns;
	OP1 <= "0011";
	wait for 10 ns;
	OP1 <= "0101";
	wait for 20 ns;
	OP1 <= "0110";
	wait for 10 ns;
	OP1 <= "0100";
	wait for 10 ns;
	A1  <= X"F0";
	B1	<= x"05";
	OP1 <= "0101";
	wait for 20 ns;
	OP1 <= "1100";
	wait for 10 ns;
	OP1 <= "1000";
	wait for 10 ns;
	OP1 <= "1001";
	wait for 10 ns;
	A1  <= X"1F";
	B1	<= x"05";
	OP1 <= "0101";
	wait for 60 ns;
end process simulation1;	

simulation2 : process
begin
	OP2 <= "0000";
	wait for 20 ns;
	OP2 <= "0111";
	A2  <= X"0A0A";
	B2	<= x"6363";
	wait for 33 ns;
	OP2 <= "0001";
	wait for 10 ns;
	OP2 <= "0010";
	wait for 10 ns;
	OP2 <= "0011";
	wait for 10 ns;
	OP2 <= "0101";
	wait for 20 ns;
	OP2 <= "0110";
	wait for 10 ns;
	OP2 <= "0100";
	wait for 10 ns;
	A2  <= X"1F1F";
	B2	<= x"0005";
	OP2 <= "0101";
	wait for 10 ns;
	OP2 <= "1100";
	wait for 10 ns;
	OP2 <= "1000";
	wait for 10 ns;
	OP2 <= "1001";
	wait for 10 ns;
	A2  <= X"0F0F";
	B2	<= x"0505";
	OP2 <= "0101";
	wait for 20 ns;
end process simulation2;	

end test;