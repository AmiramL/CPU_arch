library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

entity MUL_top is
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		b: 			in std_logic_vector(N-1 downto 0);
		o: 			out std_logic_vector(2*N-1 downto 0));
end MUL_top;

architecture MUL_arch of MUL_top is
begin
	process(a,b)
	begin
		o <= SIGNED(a)*SIGNED(b);
	end process;
end MUL_arch;