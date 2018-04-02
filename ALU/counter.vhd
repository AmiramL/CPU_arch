
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Ncounter is port (
	clk : 	in std_logic;
	rst :	in std_logic;
	q : 	inout std_logic_vector (1 downto 0));
end entity;
-- Architecture Definition
architecture rtl of Ncounter is
-- Component and signal declaration
Begin
process (clk,rst) begin
	if rst = '1' then
		q <= "00";
	elsif (rising_edge(clk)) then
		q <= q + 1;
	end if;
end process;
end rtl;