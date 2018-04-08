
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
signal vld_o:		std_logic;

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

DUT_TOP: entity work.arith_top
			generic map (N_1)
			port map(A,B,OP,En,clk,HI,LO,vld_o,status);
			
			
simulation1 : process
begin
	En <= '0';
 	A  <= X"55";
	B  <= X"32";
	

    OP <= "000";
	wait for 12 ns;
	OP <= "111";
	wait for 30 ns;
	En <= '1';
	wait for 20 ns;
	OP <= "001";
	wait for 7 ns;
	B  <= X"55";
	wait for 10 ns;
	OP <= "010";
	wait for 10 ns;
	B  <= X"65";
	wait for 10 ns;
	OP <= "011";
	wait for 10 ns;
	OP <= "110";
	wait for 10 ns;
	OP <= "100";
	wait for 10 ns;
	OP <= "101";
	wait for 50 ns;
	OP <= "000";
	A <= X"01";
	B <= X"0F";
	wait for 12 ns;
	OP <= "101";
	wait for 50 ns;
	OP <= "000";
	A <= X"06";
	B <= X"7F";
	wait for 12 ns;
	OP <= "101";
	wait for 50 ns;
	OP <= "111";
	wait for 100 ns;
	
	
	
end process simulation1;
	
	
	
end test;

