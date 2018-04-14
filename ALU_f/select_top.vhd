library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity select_top is
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
end select_top;

architecture select_struct of select_top is
component Nbit_mux2 is 
generic ( N: integer := 8);
port (	i_0: in std_logic_vector(N-1 downto 0); 
		i_1: in std_logic_vector(N-1 downto 0); 
		s: in std_logic; 
		o: out std_logic_vector(N-1 downto 0));
end	component;	

signal zeros: std_logic_vector(N-1 downto 0);
signal valid_out: std_logic;
signal sel: std_logic;
signal status_en: std_logic;



begin
	sel <=OP(3);
	valid <= valid_out;
	
	STATUS_GEN: for i in 0 to 5 generate
		status(i) <= status_in(i) and status_en;
	end generate STATUS_GEN;
	
	ZERO_GEN: for i in 0 to N-1 generate
	zeros(i) <= '0';
	end generate ZERO_GEN;
	
	HI_MUX: Nbit_mux2
			generic map(N)
			port map(arith_HI, zeros, sel, HI_out);
	
	LO_MUX: Nbit_mux2
			generic map (N)
			port map (arith_LO, shift_in, sel, LO_out);
			
			
	process(OP, arith_valid)
	begin
		case OP is
		when "0001" | "0011" | "0100" | "0101" | "0110" | "0111" => 
								valid_out <= arith_valid;
								status_en <= '0';
		when "0010" =>			valid_out <= arith_valid;
								status_en <= '1';
		when "1000" | "1001" => valid_out <= '1';
								status_en <= '0';
		when others 		 => valid_out <= '0';
								status_en <= '0';
		end case;	
	end process;
end select_struct;