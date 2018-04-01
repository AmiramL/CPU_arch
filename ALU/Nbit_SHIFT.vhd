library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nbit_SHIFT is --shift one bit Left/Right
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		Right_Left: in std_logic;
		En:		 	in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end Nbit_SHIFT;

architecture SHIFT_arch_behavioral of Nbit_SHIFT is
begin
	process(Right_Left, a, En)
	begin		
				--Right_Left = 1 => shift Right
				--Right_Left = 0 => shift Left
		o(N-1) <= (((not Right_Left) and a(N-2)) and En) or ((not En) and a(N-1));
		o(0)   <= ((Right_Left and a(1)) and En) or ((not En) and a(0));
		
		for n in 1 to N-2 loop
			o(n) <= (((Right_Left and a(n+1)) or ((not Right_Left) and a(n-1))) and En) or ((not En) and a(n));
		end loop;
	end process;
end SHIFT_arch_behavioral;
