library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit_mux2 is 
port (i_0: in std_logic; i_1: in std_logic; s: in std_logic; o: out std_logic);
end bit_mux2;

architecture bit_mux_behavioral of bit_mux2 is 
begin
process(s,i_0,i_1)
	begin
	if    (s = '0') then
	     o <= i_0 ;
	elsif (s = '1') then
	     o <= i_1 ;
	else
	     o <= 'Z';
	end if;
	end process;
end bit_mux_behavioral;
