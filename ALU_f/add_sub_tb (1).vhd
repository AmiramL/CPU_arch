library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE iEEE.std_logic_arith.ALL;

entity add_sub_tb is 
end add_sub_tb;

architecture test_tb_arch of add_sub_tb is
	signal a: std_logic_vector(31 downto 0);
	signal b: std_logic_vector(31 downto 0);
	signal o: std_logic_vector(31 downto 0);
	signal sub : std_logic;
	
	
	begin
		DUT_ADD_SUB: entity work.Nbit_add_sub
		generic map(16)
		port map(a,b,sub,o);
		
		simulation : process
		begin
			a <= X"00000008";
			b <= X"00000003";
			sub <= '0';
			wait for 10 ns;
			assert o = X"0000000B"
			REPORT "Test Failed"
			SEVERITY error;
			
			a <= X"FFFFFFFF";
			b <= X"00000004";
			sub <= '0';
			wait for 10 ns;
			assert o = X"00000003"
			REPORT "Test Failed"
			SEVERITY error;
			
			a <= X"00001234";
			b <= X"00001233";
			sub <= '1';
			wait for 10 ns;
			assert o = X"00000001"
			REPORT "Test Failed"
			SEVERITY error;
			
			a <= X"00001234";
			b <= X"00000000";
			sub <= '1';
			wait for 10 ns;
			assert o = X"00001234"
			REPORT "Test Failed"
			SEVERITY error;
			
			a <= X"00000000";
			b <= X"00000008";
			sub <= '1';
			wait for 10 ns;
			assert o = X"FFFFFFF8"
			REPORT "Test Failed"
			SEVERITY error;
			
			a <= X"FFFF1111";
			b <= X"00001111";
			sub <= '0';
			wait for 10 ns;
			assert o = X"FFFF2222"
			REPORT "Test Failed"
			SEVERITY error;
			
			a <= X"FFFF1111";
			b <= X"00001111";
			sub <= '1';
			wait for 10 ns;
			assert o = X"FFFF0000"
			REPORT "Test Failed"
			SEVERITY error;
		
		end process simulation;


	end test_tb_arch;