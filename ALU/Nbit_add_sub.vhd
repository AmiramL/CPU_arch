library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE iEEE.std_logic_arith.ALL;

entity Nbit_add_sub is 
generic ( N: integer := 8);
port( 	a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sub: in std_logic;
		res: out std_logic_vector(N-1 downto 0);
		zero: out std_logic;
		c_out: out std_logic); --for MAC
end Nbit_add_sub;

architecture add_sub_structural of Nbit_add_sub is
component bit_FA port(
			a, b, c_in : in std_logic;
			s, c_out : out std_logic);
end component;
signal car: std_logic_vector(N-1 downto 0);
signal b_sub: std_logic_vector(N-1 downto 0);

begin
  
  c_out <= car(N-1); 
  	
  B_CONN: for j in 0 to N-1 generate
    b_sub(j) <= b(j) xor sub;
  end generate B_CONN;
  
	FA_array: for i in 0 to N-1 generate
	
		LSB: if i=0 generate
			FA0: bit_FA port map (	
								a(i) , 
								b_sub(i) ,
								sub , 
								res(i) , 
								car(i));
		end generate LSB;
		
		UPPER_BITS: if i>0 generate
			FAX: bit_FA port map (	
								a(i) , 
								b_sub(i) ,
								car(i-1) , 
								res(i) , 
								car(i));
		end generate UPPER_BITS;
	end generate FA_array;
	
process(a,b,sub)
  begin
	if sub = '1' and SIGNED(a) = SIGNED(b) then
	       zero <= '1';
	   else
	       zero <= '0';
	   end if;  
end process;
	
end add_sub_structural;