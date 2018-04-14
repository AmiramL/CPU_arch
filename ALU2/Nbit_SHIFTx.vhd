library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nbit_SHIFTx is --shift one bit Left/Right
generic ( N: integer := 8; x: integer := 1);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		Right_Left: in std_logic;
		En:		 	in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end Nbit_SHIFTx;

architecture SHIFTx_arch_behavioral of Nbit_SHIFTx is

signal zeros: std_logic_vector(x-1 downto 0);

begin	
	
		ZERO_GEN: for i in 0 to x-1 generate
			zeros(i) <= '0';
		end generate ZERO_GEN;
		process(a,Right_Left,En)
		begin
				--Right_Left = 1 => shift Right
				--Right_Left = 0 => shift Left
		if En = '1' then
			if Right_Left = '0' then
				o(x-1 downto 0) <= zeros;
				o(N-1 downto x) <= a(N-x-1 downto 0);
			else
				o(N-1 downto N-x) <= zeros;
				o(N-x-1 downto 0) <= a(N-1 downto x);
			end if;
		else
			o <= a;
		end if;
	end process;
end SHIFTx_arch_behavioral;
