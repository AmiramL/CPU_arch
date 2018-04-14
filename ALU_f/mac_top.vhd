library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAC_top is
generic ( N: integer := 8);
port (	En:		 	in std_logic;
		rst:		in std_logic;
		clk:		in std_logic;
		add_res:	in std_logic_vector(2*N-1 downto 0);
		o: 			out std_logic_vector(2*N-1 downto 0);
		state_out:	out std_logic);
end MAC_top;

architecture MAC_struct of MAC_top is
component Ndff 
	generic ( N: integer := 8);
	port(
		d:				in std_logic_vector(N-1 downto 0);
		clk,rst: 		in std_logic;  
		q: 				out std_logic_vector(N-1 downto 0));
end component;


signal HI_out: std_logic_vector(N-1 downto 0);
signal LO_out: std_logic_vector(N-1 downto 0);
signal dff_clk: std_logic := '0';
signal state: std_logic := '0';

begin
MAC_REG_HI: Ndff generic map(N)
				 port map (add_res(2*N-1 downto N), dff_clk, rst, HI_out);
MAC_REG_LO: Ndff generic map(N)
				 port map (add_res(N-1 downto 0), dff_clk, rst, LO_out);
				 

o(N-1 downto 0)   <= LO_out;
o(2*N-1 downto N) <= HI_out;
state_out <= state;

process (clk)
begin
		if En = '1' then
			if rising_edge(clk) then
				dff_clk <= '0';
				case state is
						when '0' 	=> state <= '1';
						when others => state <= '0';
				end case;
			elsif falling_edge(clk) AND state = '1' then
				dff_clk <= '1';
			end if;
		end if;
end process;




		


		
end MAC_struct;
