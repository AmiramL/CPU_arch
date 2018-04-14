library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE IEEE.std_logic_arith.ALL;

--Test bench for ALU_TOP

entity TB_ALU is
end TB_ALU;

architecture test of TB_ALU is

constant N_1 : integer := 8;
constant N_2 : integer := 16;
constant N_3 : integer := 32;

signal A1: 			std_logic_vector(7 downto 0);
signal B1:  		std_logic_vector(7 downto 0);
signal OP1: 		std_logic_vector(3 downto 0);
signal clk:			std_logic;
signal valid1: 		std_logic;
signal HI1:     	std_logic_vector(7 downto 0);
signal LO1:     	std_logic_vector(7 downto 0);
signal status1: 	std_logic_vector(5 downto 0);

signal HI_res1: 	std_logic_vector(7 downto 0);
signal LO_res1: 	std_logic_vector(7 downto 0);
signal zero1: 	std_logic_vector(7 downto 0);

signal A2: 			std_logic_vector(15 downto 0);
signal B2:  		std_logic_vector(15 downto 0);
signal OP2: 		std_logic_vector(3 downto 0);
signal valid2: 		std_logic;
signal HI2:     	std_logic_vector(15 downto 0);
signal LO2:     	std_logic_vector(15 downto 0);
signal status2: 	std_logic_vector(5 downto 0);

signal A3: 			std_logic_vector(31 downto 0);
signal B3:  		std_logic_vector(31 downto 0);
signal OP3: 		std_logic_vector(3 downto 0);
signal valid3: 		std_logic;
signal HI3:     	std_logic_vector(31 downto 0);
signal LO3:     	std_logic_vector(31 downto 0);
signal status3: 	std_logic_vector(5 downto 0);

begin

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

ALU_8: entity work.ALU_top
	generic map (N_1)
	port map(	
		A1, B1, OP1, clk, valid1, HI1, LO1, status1);
		
ALU_16: entity work.ALU_top
	generic map (N_2)
	port map(	
		A2, B2, OP2, clk, valid2, HI2, LO2, status2);

	
simulation1 : process
variable number : integer;
procedure check_values8 (
						HI_e, LO_e, status_e: 	in std_logic_vector;
						t_number:				in integer;
						valid_e: 				in std_logic) 
						is
						
	begin
		number := t_number;
		wait for 10 ns;
		ASSERT valid_e = valid1 REPORT "8bit - Test Failed - Valid : " & integer'image(number) SEVERITY error;
		ASSERT HI_e = HI1 REPORT "8bit - Test Failed - HI : " & integer'image(number) SEVERITY error;
		ASSERT LO_e = LO1 REPORT "8bit - Test Failed - LO : " & integer'image(number) SEVERITY error;
		ASSERT status_e = status1 REPORT "8bit - Test Failed - Status : " & integer'image(number) SEVERITY error;
		
		REPORT "8bit - Test Ended: " & integer'image(number);
		
	end procedure;
begin 
	
	-- first cycle - NOP
	wait for 2 ns;
	OP1 <= "0000";
	check_values8(X"00", X"00", "000000", 0, '0'); 
	OP1 <= "0111"; --first op must be RST
	A1  <= X"00";
	B1	<= x"00";
	check_values8(X"00", X"00", "000000", 1, '0');
	check_values8(X"00", X"00", "000000", 2, '1');
	OP1 <= "0001";

	-- ADD tests
	for i in 0 to 7 loop
		A1(i) <= '1';
		check_values8(X"00", A1, "000000", 3 + i, '1');
	end loop;
	A1 <= X"00";
	for i in 0 to 7 loop
		B1(i) <= '1';
		check_values8(X"00", B1, "000000",  11 + i, '1');
	end loop;
	B1 <= X"00";
	zero1 <= X"00";
	for i in 0 to 7 loop
		B1(i) <= '1';
		A1(i) <= '1';
		if (i < 7) then
			zero1(i+1) <= '1';
		end if;
		
		check_values8(X"00", zero1, "000000", 19 + i, '1');
	end loop;
	-- sub tests
	OP1 <= "0010";
	A1 <= X"00";
	B1 <= X"00";
	for i in 0 to 7 loop
		A1(i) <= '1';
		if (i <7) then
		check_values8(X"00", A1, "001110", 27 + i, '1');
		else
		end if;
	end loop;
	A1 <= X"00";
	zero1 <= X"FF";
	for i in 0 to 7 loop
		if i > 0 then
		zero1(i) <= '0';
		end if;
		B1(i) <= '1';
		if i < 7 then
		check_values8(X"00", zero1, "110010", 35 + i, '1');
		else
		check_values8(X"00", zero1, "001110", 35 + i, '1');
		end if;
	end loop;
	B1 <= X"00";
	for i in 0 to 7 loop
		B1(i) <= '1';
		A1(i) <= '1';
		check_values8(X"00", X"00", "000101", 43 + i, '1');
	end loop;
	--  MIN MAX test
	-- both positive
	A1 <= X"05";
	B1 <= X"0A";
	OP1 <= "0011";
	check_values8(X"00", A1, "000000", 51, '1');
	OP1 <= "0110";
	check_values8(X"00", B1, "000000", 52, '1');
	-- A positive
	-- B negative
	A1 <= X"05";
	B1 <= X"AA";
	OP1 <= "0011";
	check_values8(X"00", B1, "000000", 53, '1');
	OP1 <= "0110";
	check_values8(X"00", A1, "000000", 54, '1');
	-- B positive
	-- A negative
	A1 <= X"A5";
	B1 <= X"0F";
	OP1 <= "0011";
	check_values8(X"00", A1, "000000", 55, '1');
	OP1 <= "0110";
	check_values8(X"00", B1, "000000", 56, '1');
	-- both negative
	A1 <= X"F5";
	B1 <= X"FA";
	OP1 <= "0011";
	check_values8(X"00", A1, "000000", 57, '1');
	OP1 <= "0110";
	check_values8(X"00", B1, "000000", 58, '1');
	-- MAC test
	OP1 <= "0111";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC reset 1"  SEVERITY error;
	check_values8(X"00", X"00", "000000", 59, '1');
	OP1 <= "0101";
	A1 <= X"02";
	B1 <= X"05";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC 1"  SEVERITY error;
	check_values8(X"00", X"0A", "000000", 60, '1');
	A1 <= X"7F";
	B1 <= X"50";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC 2"  SEVERITY error;
	check_values8(X"27", X"BA", "000000", 61, '1');
	A1 <= X"02";
	B1 <= X"05";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC 3"  SEVERITY error;
	check_values8(X"27", X"C4", "000000", 62, '1');
	OP1 <= "0111";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC reset 2"  SEVERITY error;
	check_values8(X"00", X"00", "000000", 63, '1');
	OP1 <= "0101";
	A1 <= X"50";
	B1 <= X"7F";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC 4"  SEVERITY error;
	check_values8(X"27", X"B0", "000000", 64, '1');
	A1 <= X"AA";
	B1 <= X"05";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC 5"  SEVERITY error;
	check_values8(X"26", X"02", "000000", 65, '1');
	--mul tests
	OP1 <= "0100";
	-- both positive
	A1 <= X"50";
	B1 <= X"7F";
	check_values8(X"27", X"B0", "000000", 66, '1');
	-- one pos one neg
	A1 <= X"AA";
	B1 <= X"05";
	check_values8(X"FE", X"52", "000000", 67, '1');
	B1 <= X"AA";
	A1 <= X"05";
	check_values8(X"FE", X"52", "000000", 68, '1');
	-- both begative
	B1 <= X"AA";
	A1 <= X"AF";
	check_values8(X"1B", X"36", "000000", 69, '1');
	-- ilegal ops
	B1 <= X"08";
	OP1 <= "0000";
	check_values8(X"00", X"00", "000000", 70, '0');
	OP1 <= "1010";
	check_values8(X"00", X"00", "000000", 71, '0');
	OP1 <= "1011";
	check_values8(X"00", X"FF", "000000", 72, '0');
	OP1 <= "1100";
	check_values8(X"00", X"00", "000000", 73, '0');
	OP1 <= "1101";
	check_values8(X"00", X"FF", "000000", 74, '0');
	OP1 <= "1110";
	check_values8(X"00", X"00", "000000", 75, '0');
	OP1 <= "1111";
	check_values8(X"00", X"FF", "000000", 76, '0');
	-- SHL
	OP1 <= "1000";
	A1 <= X"FF";
	B1 <= X"04";
	check_values8(X"00", X"F0", "000000", 77, '1');
	B1 <= X"05";
	check_values8(X"00", X"E0", "000000", 78, '1');
	B1 <= X"03";
	check_values8(X"00", X"F8", "000000", 79, '1');
	B1 <= X"08";
	check_values8(X"00", X"00", "000000", 80, '1');
	-- SHR
	OP1 <= "1001";
	A1 <= X"80";
	B1 <= X"03";
	check_values8(X"00", X"F0", "000000", 81, '1');
	B1 <= X"05";
	check_values8(X"00", X"FC", "000000", 82, '1');
	B1 <= X"01";
	check_values8(X"00", X"C0", "000000", 83, '1');
	B1 <= X"08";
	check_values8(X"00", X"FF", "000000", 84, '1');
	
	-- random operations in succession
	OP1 <= "0101";
	A1 <= X"02";
	B1 <= X"50";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC 6"  SEVERITY error;
	check_values8(X"26", X"A2", "000000", 85, '1');
	OP1 <= "0001";
	check_values8(X"00", X"52", "000000", 86, '1');
	OP1 <= "0110";
	check_values8(X"00", X"50", "000000", 87, '1');
	OP1 <= "0100";
	A1 <= X"04";
	check_values8(X"01", X"40", "000000", 88, '1');
	OP1 <= "1001";
	A1 <= X"03";
	B1 <= X"07";
	check_values8(X"00", X"00", "000000", 89, '1');
	OP1 <= "0010";
	check_values8(X"00", X"B4", "110010", 90, '1');
	B1 <= X"0A";
	OP1 <= "1010";
	check_values8(X"00", X"00", "000000", 91, '0');
	OP1 <= "0101";
	A1 <= X"02";
	B1 <= X"05";
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC 6"  SEVERITY error;
	check_values8(X"26", X"AC", "000000", 92, '1');
	wait for 10 ns;
	ASSERT valid1 = '0' REPORT "8bit - Test Failed - Valid : MAC 6"  SEVERITY error;
	check_values8(X"26", X"B6", "000000", 93, '1');
	OP1 <= "0001";
	check_values8(X"00", X"07", "000000", 94, '1');
	OP1 <= "0110";
	check_values8(X"00", X"05", "000000", 95, '1');
	OP1 <= "0100";
	A1 <= X"04";
	check_values8(X"00", X"14", "000000", 96, '1');
	OP1 <= "1001";
	A1 <= X"03";
	B1 <= X"07";
	check_values8(X"00", X"00", "000000", 97, '1');
	OP1 <= "0010";
	check_values8(X"00", X"FC", "110010", 98, '1');
	B1 <= X"0A";
	OP1 <= "1010";
	check_values8(X"00", X"00", "000000", 99, '0');
	OP1 <= "1000";
	A1 <= X"02";
	B1 <= X"01";
	check_values8(X"00", X"04", "000000", 100, '1');
	wait for 10 ns;

end process simulation1;	

simulation2 : process
begin
	OP2 <= "0000";
	wait for 20 ns;
	OP2 <= "0111";
	A2  <= X"0A0A";
	B2	<= x"6363";
	wait for 33 ns;
	OP2 <= "0001";
	wait for 10 ns;
	OP2 <= "0010";
	wait for 10 ns;
	OP2 <= "0011";
	wait for 10 ns;
	OP2 <= "0101";
	wait for 20 ns;
	OP2 <= "0110";
	wait for 10 ns;
	OP2 <= "0100";
	wait for 10 ns;
	A2  <= X"1F1F";
	B2	<= x"0005";
	OP2 <= "0101";
	wait for 10 ns;
	OP2 <= "1100";
	wait for 10 ns;
	OP2 <= "1000";
	wait for 10 ns;
	OP2 <= "1001";
	wait for 10 ns;
	A2  <= X"0F0F";
	B2	<= x"0505";
	OP2 <= "0101";
	wait for 20 ns;
end process simulation2;	

end test;