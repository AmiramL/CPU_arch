
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;


entity TB_2 is
end TB_2;

architecture test of TB_2 is
constant N_1 : integer := 8;
signal A: 		std_logic_vector(7 downto 0);
signal B:  		std_logic_vector(7 downto 0);
signal OP: 		std_logic_vector(2 downto 0);
signal clk:		std_logic;
signal En: 		std_logic;
signal HI:     	std_logic_vector(7 downto 0);
signal LO:     	std_logic_vector(7 downto 0);
signal status: 	std_logic_vector(5 downto 0);

begin
CLK_PROCESS: process
begin
while (0 = 0) loop
  wait for 5 ns;
	clk <= '0';
	wait for 5 ns;
	clk <= '1';
end loop;
end process;

DUT_MAC: entity work.arith_top
			generic map (N_1)
			port map(A,B,OP,clk,En,HI,LO,status);
			
			
simulation1 : process
begin
	En <= '1';
	OP <= "001";
	A  <= X"55";
	B  <= X"32";
	wait for 7 ns;
	OP <= "010";
	B  <= X"55";
	wait for 10 ns;
	B  <= X"65";
	wait for 10 ns;
	OP <= "011";
	wait for 10 ns;
	OP <= "110";
	wait for 10 ns;
	OP <= "100";
	B  <= X"03";
	wait for 10 ns;
	OP <= "101";
	wait for 50 ns;
	En <= '0';
	wait for 10 ns;
	En <= '1';
	wait for 50 ns;
	OP <= "111";
	wait for 10 ns;
	
end process simulation1;
	
	
	
end test;

