library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

--Test bench for ALU_TOP

entity TB_shiftX is
end TB_shiftX;

architecture test of TB_shiftX is
signal a: 			std_logic_vector(31 downto 0);  
signal o1: 			std_logic_vector(31 downto 0);
signal o2: 			std_logic_vector(31 downto 0); 
signal o3: 			std_logic_vector(31 downto 0);
signal Right_Left: 	std_logic;
signal En:		 	std_logic;

begin

DUT_SHIFT4: entity work.Nbit_SHIFTx
		generic map(32, 4)
		port map(a, Right_Left, En, o1);
		
DUT_SHIFT8: entity work.Nbit_SHIFTx
		generic map(32, 8)
		port map(a, Right_Left, En, o2);

DUT_SHIFT16: entity work.Nbit_SHIFTx
		generic map(32, 16)
		port map(a, Right_Left, En, o3);
		
	simulation : process
		begin
			a <= X"FFFFFFFF";
			Right_Left <= '1';
			En <= '0';
			wait for 2 ns;
			En <= '1';
			wait for 2 ns;
			En <= '0';
			Right_Left <= '0';
			wait for 2 ns;
			En <= '1';
			wait for 2 ns;
			
		
		end process simulation;
		
		
end test;