library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bit_FA is port( 	a: in std_logic; 
						b: in std_logic; 
						c_in: in std_logic; 
						s: out std_logic; 
						c_out: out std_logic );
end bit_FA;

architecture FA_behavioral of bit_FA is
begin

	S <= a xor b xor c_in;
	c_out <= (a and b) or (a and c_in) or (b and c_in);

end FA_behavioral;	
