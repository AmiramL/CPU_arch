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
		status: out std_logic_vector(5 downto 0));
end arith_top;

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
end component;
component Nbit_mux2
generic ( N: integer := 8);
port (i_0: in std_logic_vector(N-1 downto 0); i_1: in std_logic_vector(N-1 downto 0); s: in std_logic; o: out std_logic_vector(N-1 downto 0));
end component;


signal MAC2ADD: std_logic_vector(N-1 downto 0);
signal ADD2MAC: std_logic_vector(N-1 downto 0);
signal min_max_out: std_logic_vector(N-1 downto 0);
signal sub: std_logic;
signal eq: std_logic;
signal add_res: std_logic_vector(N-1 downto 0);
signal mul_res: std_logic_vector(N-1 downto 0);
signal a2add: std_logic_vector(N-1 downto 0);
signal b2add: std_logic_vector(N-1 downto 0);
signal mac_op: std_logic;
signal mac_rst: std_logic;
signal mac_out: std_logic_vector(2*N-1 downto 0);
signal mac_state: std_logic_vector(1 downto 0);
signal mul2add: std_logic_vector(N-1 downto 0);






begin
	mac_op <= OP(2) and OP(0);
	mac_rst <= OP(2) and OP(0) and OP(1);
	sub <= OP(1);
	-- status process
	process (OP)
	begin
		case OP is
		when "010" =>
			status(0) <= eq; -- A = B
			status(1) <= not eq;  -- A != B
			status(2) <= not add_res(N-1);  -- A >= B
			status(3) <= (not add_res(N-1)) and (not eq); --
			status(4) <= add_res(N-1);
			status(5) <= add_res(N-1) and (not eq);
		when others => status <= "000000";
		end case;
	end process;
	
	process (mac_state)
	begin
		case mac_state is
		when "01" => mul2add <= mul_res(N-1 downto 0);
		when "10" => mul2add <= mul_res(2*N-1 downto N);
		when others => mul2add <= B;
		end case;
	end process;
		
	MIN_MAX: Nbit_mux2
		generic map(N)
		port map(A,B,add_res(N-1),min_max_out);
	ADD_SUB: Nbit_add_sub
		generic map(N)
		port map(a2add,b2add , sub, add_res, eq);
	MUL: MUL_top generic map (N)
				 port map ( A, B, mul_res);
				 
	MAC: MAC_top generic map(N)
		port map(mac_op, mac_rst, clk, add_res, mac_out, MAC2ADD, mac_state);
	
	A2ADD_MUX: Nbit_mux2
		generic map(N)
		port map(MAC2ADD,A,mac_op,a2add);
	B2ADD_MUX: Nbit_mux2
		generic map(N)
		port map(mul2add,B,mac_op,b2add);
	
	process(OP)
	begin
		case OP is
			when "001" | "010" => LO <= add_res;
			when "011" | "110" => LO <= min_max_out;
			when "1X1" 	=>
							LO <= mac_out(N-1 downto 0);
							HI <= mac_out(N-1 downto 0);
			when "100"  =>
							LO <= mul_res(N-1 downto 0);
							HI <= mul_res(N-1 downto 0);
			when others =>  LO <= "0"; HI <= "0";
		end case;
	end process;
	
		
end arith_arch;