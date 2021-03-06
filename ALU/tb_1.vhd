library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
USE ieee.std_logic_arith.ALL;


entity TB_1 is
end TB_1;

architecture test of TB_1 is
	
	-- "Time" that will elapse between test vectors we submit to the component.
	constant TIME_DELTA : time := 100 ns;
	-- adder_combinatorial GENERICS
	constant N_1 : integer := 8;
	constant N_2 : integer := 16;
	constant N_3 : integer := 32;
	
	signal a1: std_logic_vector(7 downto 0);
	signal a2: std_logic_vector(15 downto 0);	
	signal a3: std_logic_vector(31 downto 0);	
	signal o1: std_logic_vector(7 downto 0);
	signal o2: std_logic_vector(15 downto 0);	
	signal o3: std_logic_vector(31 downto 0);	
	signal b1: std_logic_vector(4 downto 0);
	signal b2: std_logic_vector(4 downto 0);
	signal b3: std_logic_vector(4 downto 0);
	signal RL1: std_logic;
	signal RL2: std_logic;
	signal RL3: std_logic;
	
	signal A: std_logic_vector(7 downto 0);
	signal B: std_logic_vector(7 downto 0);
	signal sub: std_logic;
	signal res: std_logic_vector(7 downto 0);
	signal c_out: std_logic;
	signal o_mul: std_logic_vector(15 downto 0);
	
	signal clk:		std_logic;
	
	
	begin
	
	DUT1: entity work.SHIFT_top --SHIFT
			generic map(N_1)
			port map (a1, b1, RL1, o1);
	DUT2: entity work.SHIFT_top --SHIFT
			generic map(N_2)
			port map (a2, b2, RL2, o2);
	DUT3: entity work.SHIFT_top --SHIFT
			generic map(N_3)
			port map (a3, b3, RL3, o3);
		
	DUT4: entity work.Nbit_add_sub --adder subber
			generic map(N_1)
			port map (A, B, sub, res, c_out);
	DUT5: entity work.MUL_top
      generic map(N_1)
			port map (A, B, clk ,o_mul);
			
	CLK_PROCESS: process
	begin
		clk <= '0';
	while (0 = 0) loop
	  wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
	end loop;
	end process;
	
	simulation1  : process
	begin
	  wait for TIME_DELTA;
		a1 <= X"FF";
		b1 <= "00101";
		RL1 <= '1';
		wait for TIME_DELTA;
	end process simulation1;
	
	simulation2  : process
	begin
		a2 <= X"FFFF";
		b2 <= "00111";
		RL2 <= '0';
		wait for TIME_DELTA;
	end process simulation2;
	
	simulation3  : process
	begin
		a3 <= X"FFFFFFFF";
		b3 <= "10101";
		RL3 <= '1';
		wait for TIME_DELTA;
	end process simulation3;
	
	simulation4  : process
	begin
	  A <= X"55";
		B <= X"65";
		sub <= '1';
		wait for TIME_DELTA;
		A <= X"01";
		B <= X"01";
		sub <= '1';
		wait for TIME_DELTA;
		A <= X"5A";
		B <= X"05";
		sub <= '1';
		wait for TIME_DELTA;
		A <= X"FE";
		B <= X"FE";
		sub <= '1';
		wait for TIME_DELTA;
		A <= X"FE";
		B <= X"FF";
		sub <= '1';
		wait for TIME_DELTA;
	end process simulation4;
		
		
	end test;