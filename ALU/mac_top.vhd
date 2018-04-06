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
		busy:		out std_logic;
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

signal state: std_logic_vector(1 downto 0);
signal HI_in: std_logic_vector(N-1 downto 0);
signal LO_in: std_logic_vector(N-1 downto 0);
signal HI_out: std_logic_vector(N-1 downto 0);
signal HI2ADD: std_logic_vector(N-1 downto 0);
signal LO_out: std_logic_vector(N-1 downto 0);
signal cnt_rst: std_logic;
signal dff_clk: std_logic;

begin


MAC_REG_HI: Ndff generic map(N)
				 port map (HI_in, clk, rst, HI_out);
MAC_REG_LO: Ndff generic map(N)
				 port map (LO_in, clk, rst, LO_out);
				 
HI_FOR_ADDER: for i in 0 to N-1 generate
			HI2ADD(i) <= HI_out(i) xor c_in;
			end generate HI_FOR_ADDER;

			
dff_clk <= clk and En;  
state_out <= state;
o(N-1 downto 0)   <= LO_out;
o(2*N-1 downto N) <= HI_out;

		
process(clk)
begin
	if rising_edge(clk) then
		if En = '1' then
			if rst = '1' then
				state <= "00";
				busy <= '0';
				HI_in <= HI_out;
				LO_in <= LO_out;
				o_middle <= LO_out;
			else
				case state is
					when "00" => o_middle <= LO_out;
								 HI_in <= HI_out;
								 LO_in <= LO_out;
								 mac_sub <= '0';
								 state <= "01";
								 busy <= '1';
					when "01" => LO_in <= add_res;
								 o_middle <= HI2ADD;
								 mac_sub <= c_in;
								 state <= "10";
								 busy <= '1';
					when "10" => HI_in 	  <= add_res;
								 state <= "11";
								 busy <= '1';
					when others => 	HI_in <= HI_out;
									LO_in <= LO_out;
									state <= "00";
									busy <= '0';
				end case;
			end if;
		else
			state <= "00";
			busy <= '0';
			HI_in <= HI_out;
			LO_in <= LO_out;
		end if;
	end if;
end process;

		
end MAC_struct;
