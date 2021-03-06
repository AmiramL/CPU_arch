library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

entity arith_top is
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
end arith_top;

architecture arith_arch of arith_top is
--MAC
component MAC_top
generic ( N: integer := 8);
port (	En:		 	in std_logic;
		rst:		in std_logic;
		clk:		in std_logic;
		add_res:	in std_logic_vector(2*N-1 downto 0);
		o: 			out std_logic_vector(2*N-1 downto 0);
		state_out:	out std_logic);
end component;

component Nbit_add_sub
generic ( N: integer := 8);
port( 	a: in std_logic_vector(2*N-1 downto 0);
		b: in std_logic_vector(2*N-1 downto 0);
		sub: in std_logic;
		res: out std_logic_vector(2*N-1 downto 0)
		);
end component;


component MUL_top
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);  
		b: 			in std_logic_vector(N-1 downto 0);
		o: 			out std_logic_vector(2*N-1 downto 0));
end component;

component Nbit_mux2
generic ( N: integer := 8);
port (	i_0: in std_logic_vector(N-1 downto 0); 
		i_1: in std_logic_vector(N-1 downto 0); 
		s: in std_logic; 
		o: out std_logic_vector(N-1 downto 0));
end component;


--min max signals
signal min_max_out: std_logic_vector(N-1 downto 0);
signal min_max_sel: std_logic;
-- signals fo add_sub and status
signal eq: std_logic;
signal sub: std_logic;
signal a2add: std_logic_vector(2*N-1 downto 0);
signal b2add: std_logic_vector(2*N-1 downto 0);
signal a_padded: std_logic_vector(2*N-1 downto 0);
signal b_padded: std_logic_vector(2*N-1 downto 0);
--results
signal add_res: std_logic_vector(2*N-1 downto 0);
signal mul_res: std_logic_vector(2*N-1 downto 0);

-- signals for MAC
signal mac_op: std_logic;
signal mac_rst: std_logic;
signal mac_out: std_logic_vector(2*N-1 downto 0);
signal mac_state: std_logic;
-- tieoff to 0
signal zeros:std_logic_vector(N-1 downto 0);
--general signals
signal hi: std_logic_vector(N-1 downto 0);
signal lo: std_logic_vector(N-1 downto 0);
signal valid: std_logic;





begin
	--static assignments
	mac_op <= OP(2) and OP(0) and en;
	mac_rst <= OP(2) and OP(0) and OP(1) and en;
	sub <= OP(1);
	a_padded(N-1 downto 0) <= A;
	a_padded(2*N-1 downto N) <= zeros;
	b_padded(N-1 downto 0) <= B;
	b_padded(2*N-1 downto N) <= zeros;
	HI_out <= hi;
	LO_out <= lo;
	vld_o <= valid;
	min_max_sel <= OP(0) xor add_res(N-1);
	ZERO_GEN: for i in 0 to N-1 generate
	zeros(i) <= '0';
	end generate ZERO_GEN;
	
	--instances	
	MIN_MAX: Nbit_mux2
		generic map(N) 
		port map( A, B, min_max_sel, min_max_out);

	ADD_SUB: Nbit_add_sub
		generic map(N)
		port map(a2add,b2add , sub, add_res);
		
	MUL: MUL_top generic map (N)
				 port map ( A, B, mul_res);		
				 
	MAC: MAC_top generic map(N)
		port map(mac_op, mac_rst, clk, add_res, mac_out, mac_state);
	
	A2ADD_MUX: Nbit_mux2
		generic map(2*N)
		port map(a_padded,mac_out,mac_op,a2add);
		
	B2ADD_MUX: Nbit_mux2
		generic map(2*N)
		port map(b_padded,mul_res,mac_op,b2add);
	
		
	-- status
	status(0) <= eq; -- A = B
	status(1) <= not eq;  -- A != B
	status(2) <= not add_res(N-1);  -- A >= B
	status(3) <= (not add_res(N-1)) and (not eq); -- A > B
	status(4) <= add_res(N-1); -- A <= B
	status(5) <= add_res(N-1) and (not eq); -- A < B
	
	--main process
	process(clk)
	begin
		if rising_edge(clk) AND en = '1' then
				case OP is
					when "001" | "010" =>	lo <= add_res(N-1 downto 0);
											hi <= zeros;
											valid <= '1';
											
					when "011" | "110" => 	lo <= min_max_out;
											hi <= zeros; 
											valid <= '1';

					when "101" | "111" => 	valid <= mac_state;
											lo <= mac_out(N-1 downto 0);
											hi <= mac_out(2*N-1 downto N);
											
					when "100"  => 			lo <= mul_res(N-1 downto 0);
											hi <= mul_res(2*N-1 downto N);
											valid <= '0';
					when others => 			lo <= zeros ; hi <= zeros;
											valid <= '0';
				end case;
		end if;
	end process;
	
	process(a,b)
	begin
		if SIGNED(A) = SIGNED(B) then
			eq <= '1';
		else
			eq <= '0';
		end if;
	end process;
	
		
end arith_arch;