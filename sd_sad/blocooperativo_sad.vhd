library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blocooperativo_sad is
	generic(
		datawidth: positive;
		addresswidth: positive);
	port(
		-- control in
		ck, reset, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : in std_logic;
		-- data in
		pA, pB: in std_logic_vector(datawidth-1 downto 0);
		-- controll out
		ender: out std_logic_vector(addresswidth-1 downto 0);
		menor: out std_logic;
		sad: out std_logic_vector(datawidth+addresswidth-1 downto 0)
	);
end entity;

architecture archstruct of blocooperativo_sad is
-- COMPLETE

component registerN is
	generic(	width: natural;
				resetValue: integer := 0 );
	port(	-- control
			clock, reset, load: in std_logic;
			-- data
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0));
end component;

component multiplexer2x1 is
	generic(	width: positive );
	port(	input0, input1: in std_logic_vector(width-1 downto 0);
			sel: in std_logic;
			output: out std_logic_vector(width-1 downto 0) );
end component;

component addersubtractor is
	generic(	N: positive;
				isAdder: boolean;
				isSubtractor: boolean);
	port(	op: in std_logic;
			a, b: in std_logic_vector(N-1 downto 0);
			result: out std_logic_vector(N-1 downto 0);
			ovf, cout: out std_logic );
end component;

component absN is
	generic(	width: positive := 8 );
	port(	input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0) );
end component;

signal saidapA, saidapB, saidaSubtrator, saidaABS: std_logic_vector(datawidth-1 downto 0);
signal saidaABScomZero, saidaSomadorMem, saidaMuxSoma, saidaSoma: std_logic_vector((addresswidth + datawidth)-1 downto 0);
signal saidaMuxI, saidaI, saidaSomadorIMaior: std_logic_vector(addresswidth downto 0);
signal saidaImenor, saidaSomadorI, temp: std_logic_vector(addresswidth-1 downto 0);
signal coutSomadorI: std_logic;

begin
    -- COMPLETE
	 
	 saidaImenor <= saidaI(saidaI'length-2 downto 0);
	 
	 menor <= not(saidaI(saidaI'length-1));
	 
	 ender <= saidaImenor;
	 
	 saidaSomadorIMaior <= coutSomadorI & saidaSomadorI;
	 
	 temp <= (others => '0');
	 
	 saidaABScomZero <= temp & saidaABS;
	 
	 somadorISoma: addersubtractor
		generic map(N => datawidth+addresswidth, isAdder => True, isSubtractor => False)
		port map(op => '0', a => saidaSoma, b => saidaABScomZero,
				result => saidaSomadorMem, ovf=> open, cout => open);
	 
	 subtratorAmenosB: addersubtractor
		generic map(N => datawidth, isAdder => False, isSubtractor => True)
		port map(op => '1', a => saidapA, b => saidapB,
				result => saidaSubtrator, ovf=> open, cout => open);
	 
	 somadorI: addersubtractor
		generic map(N => addresswidth, isAdder => True, isSubtractor => False)
		port map(op => '0', a => saidaImenor, b => std_logic_vector(to_unsigned(1, addresswidth)),
				result => saidaSomadorI, ovf=> open, cout => coutSomadorI);
	 
	 absoluto: absN
		generic map(width=> datawidth)
		port map(input => saidaSubtrator, output => saidaABS );
	 
	 muxI: multiplexer2x1
		generic map(width => addresswidth+1)
		port map(input0 => saidaSomadorIMaior, input1 => std_logic_vector(to_unsigned(0, addresswidth+1)),
				   sel => zi, output => saidaMuxI);
	
	 muxSoma: multiplexer2x1
		generic map(width => datawidth+addresswidth)
		port map(input0 => saidaSomadorMem, input1 => std_logic_vector(to_unsigned(0, datawidth+addresswidth)),
				   sel => zsoma, output => saidaMuxSoma);
	 
	 regI: registerN
		 generic map(width => addresswidth+1, resetValue => 0 )
		 port map(clock => ck, reset => reset, load => ci,
				    input => saidaMuxI, output=> saidaI);
	 
	 regpA: registerN
		 generic map(width => datawidth, resetValue => 0 )
		 port map(clock => ck, reset => reset, load => cpA,
				    input => pA, output=> saidapA);
	
	 regpB: registerN
		 generic map(width => datawidth, resetValue => 0 )
		 port map(clock => ck, reset => reset, load => cpB,
				    input => pB, output=> saidapB);
	 
	 regSoma: registerN
		 generic map(width => datawidth+addresswidth, resetValue => 0 )
		 port map(clock => ck, reset => reset, load => csoma,
				    input => saidaMuxSoma, output=> saidaSoma);
	 
	 regSAD: registerN
		 generic map(width => datawidth+addresswidth, resetValue => 0 )
		 port map(clock => ck, reset => reset, load => csad_reg,
				    input => saidaSoma, output=> sad);

	 
	 
	 
end architecture;