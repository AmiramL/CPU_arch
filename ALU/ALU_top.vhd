library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity arith_top is
generic ( N: integer := 8);
port (	
		A: 		in std_logic_vector(N-1 downto 0);
		B:  	in std_logic_vector(N-1 downto 0);
		OP: 	in std_logic_vector(2 downto 0);
		en: 	in std_logic;
		clk:	in std_logic;
		HI:     out std_logic_vector(N-1 downto 0);
		LO:     out std_logic_vector(N-1 downto 0);
		status: out std_logic_vector(5 downto 0);
end ALU_top;

architecture arith_arch of arith_top is
component MAC_top
generic ( N: integer := 8);
port (	En:		 	in std_logic;
		rst:		in std_logic;
		clk:		in std_logic;
		add_res:	in std_logic_vector(N-1 downto 0);
		o: 			out std_logic_vector(2*N-1 downto 0);
		o_middle:	inout std_logic_vector(N-1 downto 0);
		state_out: 	out std_logic_vector(1 downto 0));
end component;
component Nbit_add_sub
generic ( N: integer := 8);
port( 	a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sub: in std_logic;
		res: out std_logic_vector(N-1 downto 0);
		zero: out std_logic );
end component;
component SHIFT_top
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);
		cnt:		in std_logic_vector(4   downto 0);
		Right_Left: in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end component;
component MUL_top
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		b: 			in std_logic_vector(N-1 downto 0);
		o: 		out std_logic_vector(2*N-1 downto 0));
end MUL_top;
component Nbit_mux2
generic ( N: integer := 8);
port (i_0: in std_logic_vector(N-1 downto 0); i_1: in std_logic_vector(N-1 downto 0); s: in std_logic; o: out std_logic_vector(N-1 downto 0));

signal op_in: std_logic_vector(3 downto 0);
signal MAC2ADD: std_logic_vector(N-1 downto 0);
signal ADD2MAC: std_logic_vector(N-1 downto 0);
signal min_max: std_logic_vector(N-1 downto 0);
signal sub: std_logic;
signal eq: std_logic;
signal add_res: std_logic_vector(N-1 downto 0);
signal a2add: std_logic_vector(N-1 downto 0);
signal b2add: std_logic_vector(N-1 downto 0);




begin
	
	sub <= OP(1);
	status(0) <= eq;
	status(1) <= not eq;
	status(2) <= not add_res(N-1);
	status(3) <= (not add_res(N-1)) and (not eq);
	status(4) <= add_res(N-1);
	status(5) <= add_res(N-1) and (not eq);
	
	
	MIN_MAX: Nbit_mux2
		generic map(N)
		port map(A,B,add_res(N-1),min_max);
	ADD_SUB: Nbit_add_sub
		generic map(N)
		port map(a2add,b2add , sub, add_res, eq);
	MAC: MAC_top generic map(N)
		port map('1')
