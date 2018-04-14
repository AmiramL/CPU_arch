library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE iEEE.std_logic_arith.ALL;

entity shift_tb is 
end shift_tb;

architecture test_tb_arch of shift_tb is
	signal a: std_logic_vector(15 downto 0);
	signal b: std_logic_vector(15 downto 0);
	signal o: std_logic_vector(15 downto 0);
	signal left_right: std_logic;
	
	begin
		DUT_SHIFT: entity work.SHIFT_top
		generic map(16)
		port map(a,b(5 downto 0),left_right,o);
		
		simulation : process
		begin
			a <= X"0080";
			b <= X"0002";
			left_right <= '1';
			wait for 10 ns;
			left_right <= '0';
			assert o = X"0020"
			REPORT "Test Failed 1"
			SEVERITY error;
			
			
			a <= X"0007";
			b <= X"0002";
			left_right <= '0';
			wait for 10 ns;
			left_right <= '0';
			assert o = X"001C"
			REPORT "Test Failed 2"
			SEVERITY error;
			
			a <= X"FF00";
			b <= X"0004";
			left_right <= '1';
			wait for 10 ns;
			left_right <= '0';
			assert o = X"FFF0"
			REPORT "Test Failed 3"
			SEVERITY error;
			
			a <= X"0FF0";
			b <= X"0004";
			left_right <= '0';
			wait for 10 ns;
			left_right <= '0';
			assert o = X"FF00"
			REPORT "Test Failed 4"
			SEVERITY error;
			
			a <= o;
			b <= X"0008";
			left_right <= '1';
			wait for 10 ns;
			left_right <= '0';
			assert o = X"FFFF"
			REPORT "Test Failed 5"
			SEVERITY error;
			
		
		
		end process simulation;


	end test_tb_arch;