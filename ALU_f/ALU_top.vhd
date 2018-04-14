library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

entity ALU_top is
generic ( N: integer := 8);
port (	
		A: 		in std_logic_vector(N-1 downto 0);
		B:  	in std_logic_vector(N-1 downto 0);
		OP: 	in std_logic_vector(3 downto 0);
		clk:	in std_logic;
		valid:	out std_logic;
		HI:     out std_logic_vector(N-1 downto 0);
		LO:     out std_logic_vector(N-1 downto 0);
		status: out std_logic_vector(5 downto 0));
end ALU_top;

architecture ALU_arch of ALU_top is

component arith_top
generic ( N: integer := 8);
port (	
		A: 		in std_logic_vector(N-1 downto 0);
		B:  	in std_logic_vector(N-1 downto 0);
		OP: 	in std_logic_vector(2 downto 0);
		en: 	in std_logic;
		clk:	in std_logic;
		HI_out: out std_logic_vector(N-1 downto 0);
		LO_out: out std_logic_vector(N-1 downto 0);
		vld_o:  out std_logic;
		status: out std_logic_vector(5 downto 0));
end component;

component SHIFT_top 
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);
		cnt:		in std_logic_vector(5   downto 0);
		Right_Left: in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end component;

component select_top is
generic ( N: integer := 8);
port (
		arith_HI: 	in std_logic_vector(N-1 downto 0);
		arith_LO: 	in std_logic_vector(N-1 downto 0);
		shift_in:	in std_logic_vector(N-1 downto 0);
		OP:			in std_logic_vector(3 downto 0);
		arith_valid: in std_logic;
		status_in:	in std_logic_vector(5 downto 0);
		HI_out:		out std_logic_vector(N-1 downto 0);
		LO_out:		out std_logic_vector(N-1 downto 0);
		status:		out std_logic_vector(5 downto 0);
		valid:		out std_logic);
end component;

signal arith_sel: std_logic;
signal arith_val: std_logic;
signal arith_HI_out: std_logic_vector(N-1 downto 0);
signal arith_LO_out: std_logic_vector(N-1 downto 0);

signal status_en: std_logic;
signal status_in: std_logic_vector(5 downto 0);

signal shift_out: std_logic_vector(N-1 downto 0);

signal valid_out: std_logic;




begin

valid <= valid_out;
arith_sel <= not OP(3);

ARITHMETIC_TOP: arith_top
				generic map (N)
				port map(	A, B,
							OP(2 downto 0), 
							arith_sel, 
							clk,
							arith_HI_out,
							arith_LO_out,
							arith_val,
							status_in);
SHIFT_U_TOP: SHIFT_top
				generic map (N)
				port map(	A, B(5 downto 0),
							OP(0),
							shift_out);
							
SELECT_UNIT: select_top
				generic map (N)
				port map( 	arith_HI_out, arith_LO_out, 
							shift_out, 
							OP,
							arith_val,
							status_in,
							HI, LO, status,
							valid_out);

	

end ALU_arch;	

