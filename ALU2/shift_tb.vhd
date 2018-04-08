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
			a <= X"0001";
			b <= X"FF11";
			left_right <= '1';
			wait for 1 ns;
			left_right <= '0';
			wait for 10 ns;
			assert o = X"0008"
			REPORT "Test Failed"
			SEVERITY error;
			a <= X"4000";
			b <= X"000F";
			left_right <= '1';
			wait for 10 ns;
			assert o = X"FF00"
			REPORT "Test Failed"
			SEVERITY error;
		
		end process simulation;


	end test_tb_arch;