library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity select_top is
generic ( N: integer := 8);
port (
		arith_HI: 	in std_logic_vector(N-1 downto 0);
		arith_LO: 	in std_logic_vector(N-1 downto 0);
		shift_in:	in std_logic_vector(N-1 downto 0);
		sel:		in std_logic;
		HI_out:		out std_logic_vector(N-1 downto 0);
		LO_out:		out std_logic_vector(N-1 downto 0));
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

begin
	
	ZERO_GEN: for i in 0 to N-1 generate
	zeros(i) <= '0';
	end generate ZERO_GEN;
	
	HI_MUX: Nbit_mux2
			generic map(N)
			port map(arith_HI, zeros, sel, HI_out);
	
	LO_MUX: Nbit_mux2
			generic map (N)
			port map (arith_LO, shift_in, sel, LO_out);
end select_struct;