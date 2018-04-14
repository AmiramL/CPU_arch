library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE iEEE.std_logic_arith.ALL;

entity mul_tb is 
end mul_tb;

architecture test_tb_arch of mul_tb is
	signal a: std_logic_vector(15 downto 0);
	signal b: std_logic_vector(15 downto 0);
	signal o: std_logic_vector(31 downto 0);

	
	
	begin
		DUT_MUL: entity work.MUL_top
		generic map(16)
		port map(a,b,o);
		
		simulation : process
		begin
			a <= X"0008";
			b <= X"0003";
			wait for 10 ns;
			assert o = X"00000018"
			REPORT "Test Failed 1"
			SEVERITY error;
			
			a <= X"FFFF";
			b <= X"0004";
			wait for 10 ns;
			assert o = X"FFFFFFFC"
			REPORT "Test Failed 2"
			SEVERITY error;
			
			a <= X"1234";
			b <= X"1233";
			wait for 10 ns;
			assert o = X"014B485C"
			REPORT "Test Failed 3"
			SEVERITY error;
			
			a <= X"1234";
			b <= X"0000";
			wait for 10 ns;
			assert o = X"00000000"
			REPORT "Test Failed 4"
			SEVERITY error;
			
			a <= X"0000";
			b <= X"4444";
			wait for 10 ns;
			assert o = X"00000000"
			REPORT "Test Failed 5"
			SEVERITY error;
			
			a <= X"1011";
			b <= X"4444";
			wait for 10 ns;
			assert o = X"0448C884"
			REPORT "Test Failed 6"
			SEVERITY error;
			
			a <= X"0008";
			b <= X"FE00";
			wait for 10 ns;
			assert o = X"FFFFF000"
			REPORT "Test Failed 7"
			SEVERITY error;
			
		
		
		end process simulation;


	end test_tb_arch;