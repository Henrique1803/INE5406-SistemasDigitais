library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blocoOperativo is
	generic(largDividendo: integer;
            largDivisor: integer);
	port (
				clock: in std_logic;
				--Entrada de dados:
            dividendo: in std_logic_vector(largDividendo-1 downto 0);
            divisor: in std_logic_vector(largDivisor-1 downto 0);
				--Saída de dados:
            quociente: out std_logic_vector(largDividendo-1 downto 0);
            resto: out std_logic_vector(largDivisor-1 downto 0);
				
				ctrlSetaResto, ctrlSetaQuocienteEmZero, ctrlSetaRestoMenosDivisor, ctrlSetaQuocienteMaisUm: in std_logic;
				sttRestoMaiorIgualDivisor: out std_logic
            );
end entity;

architecture SD of blocoOperativo is

component multiplexer2x1 is
	generic(	width: positive );
	port(	input0, input1: in std_logic_vector(width-1 downto 0);
			sel: in std_logic;
			output: out std_logic_vector(width-1 downto 0) );
end component;

component addersubtractor is
	generic(	width: positive := 4;
			isAdder: boolean := true;
			isSubtractor: boolean := true;
			generateCout: boolean := true;
			generateOvf: boolean := true);
	port(	
		a, b: in std_logic_vector(width-1 downto 0);
		op: in std_logic;
		result: out std_logic_vector(width-1 downto 0);
		ovf, cout: out std_logic );
end component;

component compare is
	generic(	width: positive;
				isSigned: boolean;
				generateLessThan: boolean;
				generateEqual: boolean );
	port(	input0, input1: in std_logic_vector(width-1 downto 0);
			lessThan, equal: out std_logic );		
end component;

component registerN is
	generic(	width: natural;
				resetValue: integer := 0 );
	port(	-- control
			clock, reset, load: in std_logic;
			-- data
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0));
end component;


signal saidaMuxResto, saidaResto, saidaSubtratorResto, saidaQuociente, saidaSomadorQuociente: std_logic_vector(largDividendo-1 downto 0);
signal ctrlSetaRestoMenosDivisorOUctrlSetaResto, saidaRestoMenorQueDivisor: std_logic;

begin

ctrlSetaRestoMenosDivisorOUctrlSetaResto <= ctrlSetaRestoMenosDivisor or ctrlSetaResto;
sttRestoMaiorIgualDivisor <= not(saidaRestoMenorQueDivisor);


registradorQuociente: registerN
	generic map(width => largDividendo, resetValue => 0)
	port map(clock => clock, reset => ctrlSetaQuocienteEmZero, load => ctrlSetaQuocienteMaisUm,
			   input => saidaSomadorQuociente, output => saidaQuociente);

somadorQuociente: addersubtractor
	generic map(width => largDividendo, isAdder => true, isSubtractor => false, generateCout => false, generateOvf => false)
	port map(a => saidaQuociente, b => std_logic_vector(to_unsigned(1, largDividendo)), op => '0',
		result => saidaSomadorQuociente, ovf => open, cout => open);

muxResto: multiplexer2x1
	generic map(width => largDividendo)
	port map(input0 => saidaSubtratorResto, input1 => dividendo,
			sel => ctrlSetaResto, output => saidaMuxResto);

registradorResto: registerN
	generic map(width => largDividendo, resetValue => 0)
	port map(clock => clock, reset => '0', load => ctrlSetaRestoMenosDivisorOUctrlSetaResto,
			   input => saidaMuxResto, output => saidaResto);
				
subtratorRestoMenosDivisor: addersubtractor
	generic map(width => largDividendo, isAdder => false, isSubtractor => true, generateCout => false, generateOvf => false)
	port map(a => saidaResto, b => divisor, op => '1',
		result => saidaSubtratorResto, ovf => open, cout => open);

componentRestoMenorQueDivisor: compare
	generic map(width => largDividendo, isSigned => false, generateLessThan => true, generateEqual => false)
	port map(input0 => saidaResto, input1 => divisor, lessThan => saidaRestoMenorQueDivisor, equal => open);

end architecture;
            
