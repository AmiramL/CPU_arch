library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAC_top is
generic ( N: integer := 8);
port (	En:		 	in std_logic;
		rst:		in std_logic;
		clk:		in std_logic;
		add_res:	in std_logic_vector(N-1 downto 0);
		o: 			out std_logic_vector(2*N-1 downto 0);
		o_middle:	inout std_logic_vector(N-1 downto 0);
		state_out: 	out std_logic_vector(1 downto 0));
end MAC_top;

architecture MAC_struct of MAC_top is
component Ndff 
	generic ( N: integer := 8);
	port(
		d:				in std_logic_vector(N-1 downto 0);
		clk,rst: 		in std_logic;  
		q: 				out std_logic_vector(N-1 downto 0));
end component;
component Ncounter
	port(
		clk,rst:	in std_logic;
		q:			inout std_logic_vector(1 downto 0));
end component;
signal state: std_logic_vector(1 downto 0);
signal HI_in: std_logic_vector(N-1 downto 0);
signal LO_in: std_logic_vector(N-1 downto 0);
signal HI_out: std_logic_vector(N-1 downto 0);
signal LO_out: std_logic_vector(N-1 downto 0);
signal cnt_rst: std_logic;
signal dff_clk: std_logic;
begin


MAC_REG_HI: Ndff generic map(N)
				 port map (HI_in, dff_clk, rst, HI_out);
MAC_REG_LO: Ndff generic map(N)
				 port map (LO_in, dff_clk, rst, LO_out);
STATE_CNT:	Ncounter port map (clk,cnt_rst,state);	
  
dff_clk <= clk and En;  
state_out <= state;
o(N-1 downto 0)   <= LO_out;
o(2*N-1 downto N) <= HI_out;
		
process(clk)
begin
if rising_edge(clk) then
	if En = '1' then
		cnt_rst <= '0';
		case state is
			when "00" => o_middle <= LO_out;
						 HI_in <= HI_out;
						 LO_in <= add_res;
			when "01" => o_middle <= HI_out;
						 HI_in <= add_res;
			when "10" => HI_in 	  <= add_res;
			when others => 	HI_in <= HI_out;
							LO_in <= LO_out;
							cnt_rst <= '0';
							
		end case;				 
	else
		cnt_rst <= '1';
	end if;
end if;
end process;
end MAC_struct;
