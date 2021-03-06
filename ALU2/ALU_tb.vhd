library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--Test bench for ALU_TOP

entity TB_ALU is
end TB_ALU;

architecture test of TB_ALU is

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

signal A3: 			std_logic_vector(31 downto 0);
signal B3:  		std_logic_vector(31 downto 0);
signal OP3: 		std_logic_vector(3 downto 0);
signal valid3: 		std_logic;
signal HI3:     	std_logic_vector(31 downto 0);
signal LO3:     	std_logic_vector(31 downto 0);
signal status3: 	std_logic_vector(5 downto 0);

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
procedure check_values (
						HI_e, LO_e, status_e: 	in std_logic_vector;
						HI_r, LO_r, status_r: 	in std_logic_vector;
						number:					in integer;
						valid_r, valid_e: 		in std_logic) 
						is
						
	begin
		wait for 10 ns;
		ASSERT valid_r = valid_e REPORT "Test Failed - Valid" SEVERITY error;
		ASSERT HI_e = HI_r REPORT "Test Failed - HI" SEVERITY error;
		ASSERT LO_e = LO_r REPORT "Test Failed - LO" SEVERITY error;
		ASSERT status_e = status_r REPORT "Test Failed - Status" SEVERITY error;
		
		REPORT "test Passed" & number;
		
	end procedure;
begin
	wait for 2 ns;
	OP1 <= "0000";
	check_values(X"00", X"00", "000000", HI1, LO1, status1, 0, '0', valid1); 
	OP1 <= "0111"; --first op must be RST
	A1  <= X"00";
	B1	<= x"00";
	check_values(X"00", X"00", "000000", HI1, LO1, status1, 1, '0', valid1);
	check_values(X"00", X"00", "000000", HI1, LO1, status1, 2, '1', valid1);
	OP1 <= "0001";
	for i in 0 to 7 loop
		A1(i) <= '1';
		check_values(X"00", A1, "000000", HI1, LO1, status1, 3 + i, '1', valid1);
	end loop;
	A1 <= X"00";
	for i in 0 to 7 loop
		B1(i) <= '1';
		check_values(X"00", B1, "000000", HI1, LO1, status1, 11 + i, '1', valid1);
	end loop;
	B1 <= X"00";
	for i in 0 to 7 loop
		B1(i) <= '1';
		A1(i) <= '1';
		check_values(X"00", A1+B1, "000000", HI1, LO1, status1, 19 + i, '1', valid1);
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