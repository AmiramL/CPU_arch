library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;

entity SHIFT_top is 
generic ( N: integer := 8);
port (	a: 			in std_logic_vector(N-1 downto 0);
		cnt:		in std_logic_vector(5 downto 0);
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
signal wires0: 	std_logic_vector(N-1 downto 0);
signal wires1: 	std_logic_vector(2*N-1 downto 0);
signal wires2: 	std_logic_vector(4*N-1 downto 0);
signal wires3: 	std_logic_vector(8*N-1 downto 0);
signal wires4: 	std_logic_vector(16*N-1 downto 0);
signal wires5: 	std_logic_vector(32*N-1 downto 0);
begin
	
	
	LSB: for i in 0 to 0 generate
	BIT0: Nbit_SHIFT 
	      generic map (N)
	      port map (a, Right_Left, cnt(0), wires0(N-1 downto 0));
	end generate LSB;
	
	SEC_BIT: if (1 < 8) generate
	BIT0: Nbit_SHIFT 
	      generic map (N)
	      port map ( wires0(N-1 downto 0), Right_Left, cnt(1), wires1(N-1 downto 0) );
	BIT1: Nbit_SHIFT 
	      generic map (N)
	      port map ( wires1(N-1 downto 0), Right_Left, cnt(1), wires1(2*N-1 downto N) );
	end generate SEC_BIT;
	
	THRD_BIT: if (1 < N) generate
		BIT10: Nbit_SHIFT 
			  generic map (N)
			  port map ( wires1(2*N-1 downto N), Right_Left, cnt(2), wires2(N-1 downto 0) );
		BIT1i: for i in 1 to 3 generate
		BITi: Nbit_SHIFT 
			generic map (N)
			port map ( wires2((N*i-1) downto (N*(i-1))), Right_Left, cnt(2), wires2((N*(i+1))-1 downto (N*i)) );
		end generate BIT1i;
	end generate THRD_BIT;
	
	FRTH_BIT: if (1 < N) generate
		BIT20: Nbit_SHIFT 
			  generic map (N)
			  port map ( wires2(4*N-1 downto 3*N), Right_Left, cnt(3), wires3(N-1 downto 0) );
		BIT1i: for i in 1 to 7 generate
		BITi: Nbit_SHIFT 
			generic map (N)
			port map ( wires3((N*i-1) downto (N*(i-1))), Right_Left, cnt(3), wires3((N*(i+1))-1 downto (N*i)) );
		end generate BIT1i;	
	end generate FRTH_BIT;
	
	FFTH_BIT: if (1 < N) generate
		BIT20: Nbit_SHIFT 
			  generic map (N)
			  port map ( wires3(8*N-1 downto 7*N), Right_Left, cnt(4), wires4(N-1 downto 0) );
		BIT2i: for i in 1 to 15 generate
		BITi: Nbit_SHIFT 
			generic map (N)
			port map ( wires4((N*i-1) downto (N*(i-1))), Right_Left, cnt(4), wires4((N*(i+1))-1 downto (N*i)) );
		end generate BIT2i;	
	end generate FFTH_BIT;
	
	SXTH_BIT: if (1 < N) generate
		BIT30: Nbit_SHIFT 
			  generic map (N)
			  port map ( wires4(16*N-1 downto 15*N), Right_Left, cnt(5), wires5(N-1 downto 0) );
		BIT3i: for i in 1 to 31 generate
		BITi: Nbit_SHIFT 
			generic map (N)
			port map ( wires5((N*i-1) downto (N*(i-1))), Right_Left, cnt(5), wires5((N*(i+1))-1 downto (N*i)) );
		end generate BIT3i;	
	end generate SXTH_BIT;
	

	o <= wires5((32*N-1) downto N*31);

			
end SHIFT_top_arch;	
		
		
			