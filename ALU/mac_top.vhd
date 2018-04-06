library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAC_top is
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
end MAC_top;

architecture MAC_struct of MAC_top is
component Ndff 
	generic ( N: integer := 8);
	port(
		d:				in std_logic_vector(N-1 downto 0);
		clk,rst: 		in std_logic;  
		q: 				out std_logic_vector(N-1 downto 0));
end component;

signal state: std_logic_vector(2 downto 0);
signal HI_out: std_logic_vector(N-1 downto 0);
signal LO_out: std_logic_vector(N-1 downto 0);
signal HI_clk: std_logic;
signal LO_clk: std_logic;

begin


MAC_REG_HI: Ndff generic map(N)
				 port map (add_res, HI_clk, rst, HI_out);
MAC_REG_LO: Ndff generic map(N)
				 port map (add_res, LO_clk, rst, LO_out);
				 


			
state_out <= state;
o(N-1 downto 0)   <= LO_out;
o(2*N-1 downto N) <= HI_out;

		
process(clk)
begin
	if rising_edge(clk) then
		if En = '1' then
			if rst = '1' then
				state <= "000";
				o_middle <= LO_out;
				HI_clk <= '1';
				LO_clk <= '1';
			else
				case state is
					when "000" => 	o_middle <= LO_out;
									mac_sub <= '0';
									HI_clk <= '0';
									LO_clk <= '0';
									state <= "001";
					when "001" => 	o_middle <= HI_out;
									mac_sub <= c_in;
									state <= "010";
									HI_clk <= '0';
									LO_clk <= '1';
					when "010" =>	state <= "011";
					when "011" =>	state <= "100";
									HI_clk <= '1';
					when "100" =>	HI_clk <= '0';
									LO_clk <= '0';
									mac_sub <= '0';
									state <= "100";
					when others => 	state <= "000";
									HI_clk <= '0';
									LO_clk <= '0';
									
				end case;
			end if;
		else
			state <= "000";
			HI_clk <= '0';
			LO_clk <= '0';
		end if;
	end if;
end process;

		
end MAC_struct;
