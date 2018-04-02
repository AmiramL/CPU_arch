library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE iEEE.std_logic_arith.ALL;

entity dff is
port (	
		d: 	  		in std_logic;
		clk:		in std_logic;
		rst:		in std_logic;
		q: 			out std_logic);
end dff;

architecture dff_behavioral of dff is
begin
	process(clk,rst)
	  begin
		if rst = '1' then
			q <= '0';
		elsif rising_edge(clk) then
			q <= d;
		end if;
		end process;	
end dff_behavioral;