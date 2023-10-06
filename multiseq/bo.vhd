library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bo is
	generic(largura: positive := 8);
	port(
		-- control in
		ck, Reset: in std_logic;
		mP, cP, mA, cA, cB, cmult, m1, m2, op: in std_logic;
		-- control out
		Az, Bz: out std_logic;
		-- data in
		entA, entB: in std_logic_vector(largura-1 downto 0);
		-- data out
		mult: out std_logic_vector(largura-1 downto 0)
	);
end entity;

architecture descricaoEstrutural of bo is

   component  registerN is
	generic(	width: natural;
				resetValue: integer := 0 );
	port(	-- control
			clock, reset, load: in std_logic;
			-- data
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0));
	end component;
	
	component compare is
	generic(	width: natural;
				isSigned: boolean;
				generateLessThan: boolean;
				generateEqual: boolean );
	port(	input0, input1: in std_logic_vector(width-1 downto 0);
			lessThan, equal: out std_logic );
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
				isSubtractor: boolean;
				generateOvf: boolean );
	port(	op: in std_logic;
			a, b: in std_logic_vector(N-1 downto 0);
			result: out std_logic_vector(N-1 downto 0);
			ovf, cout: out std_logic );
	end component;
	
	signal saidaMuxP, saidaP, saidaMuxA, saidaA, saidaB, saidaMuxBouUm, saidaMuxPouA, saidaSomSub: std_logic_vector(largura-1 downto 0);

	
begin
    -- COMPLETE COM COMANDOS CONCORRENTES 
	 
	RegistradorM: registerN
		generic map(width => largura, resetValue => 0 )
		port map(clock=>ck, reset=> Reset, load=> cmult,
		        input => saidaP, output => mult);
	 
	RegistradorP: registerN
		generic map(width => largura, resetValue => 0 )
		port map(clock=>ck, reset=> Reset, load=> cP,
		        input => saidaMuxP, output => saidaP);
	
	RegistradorA: registerN
		generic map(width => largura, resetValue => 0 )
		port map(clock=>ck, reset=> Reset, load=> cA,
		        input => saidaMuxA, output => saidaA);
	
	RegistradorB: registerN
		generic map(width => largura, resetValue => 0 )
		port map(clock=>ck, reset=> Reset, load=> cB,
		        input => entB, output => saidaB);
	
	muxP: multiplexer2x1
		generic map(width => largura)
		port map(input0 => saidaSomSub, input1 => std_logic_vector(to_unsigned(0, largura)), 
			      sel => mP, output => saidaMuxP);
	
	muxA: multiplexer2x1
		generic map(width => largura)
		port map(input0 => saidaSomSub, input1 => entA, 
			      sel => mA, output => saidaMuxA);
	
	muxPouA: multiplexer2x1
		generic map(width => largura)
		port map(input0 => saidaP, input1 => saidaA, 
			      sel => m1, output => saidaMuxPouA);
	
	muxBouUm: multiplexer2x1
		generic map(width => largura)
		port map(input0 => saidaB, input1 => std_logic_vector(to_unsigned(1, largura)), 
			      sel => m2, output => saidaMuxBouUm);
	
	somadoresubtrator: addersubtractor
		generic map(N => largura, isAdder => True, isSubtractor => True, generateOvf=> False)
		port map(op => op, a => saidaMuxPouA, b => saidaMuxBouUm,
				result => saidaSomSub, ovf=> open, cout => open);
	
	comparaAcomZero: compare
		generic map(width => largura, isSigned => False, generateLessThan => False, generateEqual => True)
		port map(input0 => saidaA, input1 => std_logic_vector(to_unsigned(0, largura)),
				lessThan => open, equal => Az);
	
	comparaBcomZero: compare
		generic map(width => largura, isSigned => False, generateLessThan => False, generateEqual => True)
		port map(input0 => saidaB, input1 => std_logic_vector(to_unsigned(0, largura)),
				lessThan => open, equal => Bz); 
	 
	 
end architecture;
