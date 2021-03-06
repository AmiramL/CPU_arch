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
		add_res:	in std_logic_vector(N-1 downto 0);
		c_in:       in std_logic;
		o: 			out std_logic_vector(2*N-1 downto 0);
		o_middle:	out std_logic_vector(N-1 downto 0);
		mac_sub:	out std_logic;
		state_out: 	out std_logic_vector(2 downto 0));
end component;

component Nbit_add_sub
generic ( N: integer := 8);
port( 	a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sub: in std_logic;
		res: out std_logic_vector(N-1 downto 0);
		zero: out std_logic; 
		c_out: out std_logic);
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
		clk:		in std_logic;
		o: 		out std_logic_vector(2*N-1 downto 0));
end component;
component Nbit_mux2
generic ( N: integer := 8);
port (i_0: in std_logic_vector(N-1 downto 0); i_1: in std_logic_vector(N-1 downto 0); s: in std_logic; o: out std_logic_vector(N-1 downto 0));
end component;


--min max signals
signal min_max_out: std_logic_vector(N-1 downto 0);
signal min_out: std_logic_vector(N-1 downto 0);
signal max_out: std_logic_vector(N-1 downto 0);
-- signals fo add_sub and status
signal sub: std_logic;
signal eq: std_logic;
signal add_res: std_logic_vector(N-1 downto 0);
signal mul_res: std_logic_vector(2*N-1 downto 0);
signal a2add: std_logic_vector(N-1 downto 0);
signal b2add: std_logic_vector(N-1 downto 0);
signal add_cout: std_logic;
-- signals for MAC
signal mac_op: std_logic;
signal mac_rst: std_logic;
signal mac_out: std_logic_vector(2*N-1 downto 0);
signal mac_state: std_logic_vector(2 downto 0);
signal mul2add: std_logic_vector(N-1 downto 0);
signal mul2add_HI: std_logic_vector(N-1 downto 0);
signal MAC2ADD: std_logic_vector(N-1 downto 0);
signal mac_sub: std_logic;
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
	sub <= OP(1) or (mac_op AND mac_sub);
	HI_out <= hi;
	LO_out <= lo;
	vld_o <= valid;
	ZERO_GEN: for i in 0 to N-1 generate
	zeros(i) <= '0';
	end generate ZERO_GEN;
	
	--instances	
	MIN_MUX: Nbit_mux2
		generic map(N) 
		port map( A, B, add_res(N-1), max_out);
	MAX_MUX: Nbit_mux2
		generic map(N) 
		port map( B, A, add_res(N-1), min_out);
	MIN_MAX: Nbit_mux2
		generic map(N) 
		port map( max_out, min_out, OP(0), min_max_out);
	MUL_2_ADD : Nbit_mux2
		generic map(N) 
		port map( mul_res(N-1 downto 0), mul2add_HI, mac_state(1), mul2add);
	ADD_SUB: Nbit_add_sub
		generic map(N)
		port map(a2add,b2add , sub, add_res, eq, add_cout);
	MUL: MUL_top generic map (N)
				 port map ( A, B, clk, mul_res);			 
	MAC: MAC_top generic map(N)
		port map(mac_op, mac_rst, clk, add_res,	add_cout, mac_out, MAC2ADD, mac_sub, mac_state);
	
	A2ADD_MUX: Nbit_mux2
		generic map(N)
		port map(A,MAC2ADD,mac_op,a2add);
	B2ADD_MUX: Nbit_mux2
		generic map(N)
		port map(B,mul2add,mac_op,b2add);
	
	MUL_HI_2_ADD: for i in 0 to N-1 generate
		mul2add_HI(i) <= mul_res(i + N) xor mac_sub;
		end generate MUL_HI_2_ADD;
		
	-- status process
	process (clk)
	begin
		if (en = '1' AND rising_edge(clk)) then
		case OP is
		when "010" =>
			status(0) <= eq; -- A = B
			status(1) <= not eq;  -- A != B
			status(2) <= not add_res(N-1);  -- A >= B
			status(3) <= (not add_res(N-1)) and (not eq); -- A > B
			status(4) <= add_res(N-1); -- A <= B
			status(5) <= add_res(N-1) and (not eq); -- A < B
		when others => status <= "000000";
		end case;
		end if;
	end process;
	
	--main process
	process(clk)
	begin
		if rising_edge(clk) AND en = '1' then
				case OP is
					when "001" =>	lo <= add_res;
									hi <= zeros;
									valid <= '1';
					when "010" => 	lo <= add_res;
									hi <= zeros;
									valid <= '1';
					when "011" => 	lo <= min_max_out;
									hi <= zeros; 
									valid <= '1';
					when "110" => 	lo <= min_max_out;
									hi <= zeros;
									valid <= '1';
					when "101" 	=> 	if mac_state = "100" then
										valid <= '1';
										lo <= mac_out(N-1 downto 0);
										hi <= mac_out(2*N-1 downto N);
									else
										lo <= mac_out(N-1 downto 0);
										hi <= mac_out(2*N-1 downto N);
										valid <= '0';
									end if;
					when "111" 	=> 	valid <= '1';
									lo <= zeros;
									hi <= zeros;
					when "100"  => 	lo <= mul_res(N-1 downto 0);
									hi <= mul_res(2*N-1 downto N);
									valid <= '1';
					when others => 	lo <= zeros ; HI <= zeros;
									valid <= '0';
				end case;
		end if;
	end process;
	
		
end arith_arch;