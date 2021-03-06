library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SHIFT_top is 
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);
		cnt:		in std_logic_vector(4   downto 0);
		Right_Left: in std_logic;
		o: 			out std_logic_vector(N-1 downto 0));
end SHIFT_top;

architecture SHIFT_top_arch of SHIFT_top is
component Nbit_SHIFT 
	generic (N: integer :=8);
	port(
		a: 				in std_logic_vector(N-1 downto 0);  
		Right_Left, En: in std_logic;
		o: 				out std_logic_vector(N-1 downto 0));
end component;
signal wires: std_logic_vector((N*(N-1)-1) downto 0);
begin
	
	o <= wires((N*(N-1)-1) downto N*(N-2));
	
	LSB: for i in 0 to 0 generate
	BIT0: Nbit_SHIFT 
	      generic map (N)
	      port map (a, Right_Left, cnt(0), wires(N-1 downto 0));
	end generate LSB;
	
	SEC_BIT: for i in 1 to 2 generate
	BITi: Nbit_SHIFT 
	      generic map (N)
	      port map ( wires((N*(i-1)) + N-1 downto (N*(i-1))), Right_Left, cnt(1), wires((N*i + N-1) downto (N*i)) );
	end generate SEC_BIT;
	
	THRD_BIT: for i in 3 to 6 generate
	BITi: Nbit_SHIFT 
	    generic map (N)
	    port map ( wires((N*(i-1)) + N-1 downto (N*(i-1))), Right_Left, cnt(2), wires((N*i + N-1) downto (N*i)) );
	end generate THRD_BIT;
	
	FRTH_BIT: for i in 7 to 14 generate
		CHECK1: if (i < N-1) generate
			BITi: Nbit_SHIFT 
			generic map (N)
	    port map ( wires((N*(i-1)) + N-1 downto (N*(i-1))), Right_Left, cnt(3), wires((N*i + N-1) downto (N*i) ));
		end generate CHECK1;	
	end generate FRTH_BIT;
	
	FFTH_BIT: for i in 15 to 30 generate
		CHECK2: if (i < N-1) generate
			BITi: Nbit_SHIFT 
			generic map (N)
	    port map ( wires((N*(i-1)) + N-1 downto (N*(i-1))), Right_Left, cnt(4), wires((N*i + N-1) downto (N*i)) );
		end generate CHECK2;	
  end generate FFTH_BIT;
		
end SHIFT_top_arch;	
		
		
			