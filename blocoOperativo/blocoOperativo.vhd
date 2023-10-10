library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blocoOperativo is
	generic(width: positive:=8);
	port(-- control input
		clock: in std_logic;
		ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6: in std_logic;
		-- control output
		stt1, stt2: out std_logic;
		-- data input
		entrada: in std_logic_vector(width-1 downto 0);
		-- data output
		j, k: out std_logic_vector(width-1 downto 0) );
end entity;

architecture behav0 of blocoOperativo is

	component registerN is
		 generic(    width: positive;
						 generateLoad: boolean := false;
						 clearValue: integer := 0 );
		 port(    -- control
					clock, clear, load: in std_logic;
					-- data
					input: in std_logic_vector(width-1 downto 0);
					output: out std_logic_vector(width-1 downto 0));
	end component;
	
	component compare is
    generic(    width: positive;
                isSigned: boolean := false;
                generateEqual: boolean := false ;
                generateLessThan: boolean := false;
                useFixedSecodOperand: boolean := false;
                fixedSecodOperand: integer := 0 );
    port(    input0, input1: in std_logic_vector(width-1 downto 0);
            lessThan, equal: out std_logic );
	end component;
	
	component multiplexer2x1 is
    generic(    width: positive );
    port(    input0, input1: in std_logic_vector(width-1 downto 0);
            sel: in std_logic;
            output: out std_logic_vector(width-1 downto 0) );
	end component;
	
	component multiplier is
    generic(    width: positive);
    port(    input0, input1: in std_logic_vector(width-1 downto 0);
            output: out std_logic_vector(2*width-1 downto 0) );
   end component;
	
	component addersubtractor is
    generic(    width: positive;
            isAdder: boolean := false;
            isSubtractor: boolean := false;
            generateCout: boolean := false;
            generateOvf: boolean := false;
            fixedSecodOperand: integer := 0);
    port(    
        a, b: in std_logic_vector(width-1 downto 0);
        op: in std_logic;
        result: out std_logic_vector(width-1 downto 0);
        ovf, cout: out std_logic );
	end component;
	
-- COMPLETE
	signal saidaMuxI, saidaI, saidaSomadorI: std_logic_vector(width-1 downto 0);
	signal saidaMuxK, saidaK, saidaMuxJ, saidaJ, saidaSomadorJK, saidaSomadorKK: std_logic_vector(width-1 downto 0);
	signal ctrl1ORctrl2, ctrl5ORctrl6, ctrl3ORctrl4, saidaMenorQueJK, saidaIgualJK: std_logic;

begin

	ctrl1ORctrl2 <= ctrl1 or ctrl2;
	ctrl5ORctrl6 <= ctrl5 or ctrl6;
	ctrl3ORctrl4 <= ctrl3 or ctrl4;
	
	stt2 <= saidaMenorQueJK or saidaIgualJK;
	
	
	muxI: multiplexer2x1
		 generic map(width => width)
		 port map(input0 => std_logic_vector(to_unsigned(1, width)), input1 => saidaSomadorI,
					sel => ctrl2, output => saidaMuxI);
	
	registradorI: registerN
		 generic map(width => width, generateLoad => true, clearValue => 0)
		 port map(clock => clock, clear => '0', load => ctrl1ORctrl2,
				    input => saidaMuxI, output => saidaI);
					 
	somadorIm1: addersubtractor
    generic map(width => width, isAdder => true, isSubtractor => false,
            generateCout => false, generateOvf => false,
            fixedSecodOperand => 1)
    port map(    
        a => saidaI, b => std_logic_vector(to_unsigned(1, width)),
        op => '0', result => saidaSomadorI,
        ovf=>open, cout => open );
	
	iMenorQue30: compare
    generic map(width => width, isSigned => false, generateEqual => false,
                generateLessThan => true, useFixedSecodOperand => true, fixedSecodOperand => 30)
    port map(input0 => saidaI, input1 => std_logic_vector(to_unsigned(30, width)),
            lessThan => stt1, equal => open);
				
	muxK: multiplexer2x1
		 generic map(width => width)
		 port map(input0 => std_logic_vector(to_unsigned(1, width)), input1 => entrada,
					sel => ctrl6, output => saidaMuxK);
	
	registradorK: registerN
		 generic map(width => width, generateLoad => true, clearValue => 0)
		 port map(clock => clock, clear => '0', load => ctrl5ORctrl6,
				    input => saidaMuxK, output => saidaK);
					 
	muxJ: multiplexer2x1
		 generic map(width => width)
		 port map(input0 => saidaK, input1 => saidaSomadorJK,
					sel => ctrl4, output => saidaMuxJ);
	
	registradorJ: registerN
		 generic map(width => width, generateLoad => true, clearValue => 0)
		 port map(clock => clock, clear => '0', load => ctrl3ORctrl4,
				    input => saidaMuxJ, output => saidaJ);
					 
	somadorKmaisK: addersubtractor
		 generic map(width => width, isAdder => true, isSubtractor => false, generateCout => false, generateOvf => false, fixedSecodOperand => 0)
		 port map(a => saidaK, b => saidaK, op => '0', result => saidaSomadorKK, ovf => open, cout => open);
	
	somadorJmaisK: addersubtractor
		 generic map(width => width, isAdder => true, isSubtractor => false, generateCout => false, generateOvf => false, fixedSecodOperand => 0)
		 port map(a => saidaK, b => saidaJ, op => '0', result => saidaSomadorJK, ovf => open, cout => open);
		
	jMenorQueK: compare
    generic map(width => width, isSigned => true, generateEqual => false,
                generateLessThan => true, useFixedSecodOperand => false, fixedSecodOperand => 0)
    port map(input0 => saidaJ, input1 => saidaK,
            lessThan => saidaMenorQueJK, equal => open);
	
	jIgualK: compare
    generic map(width => width, isSigned => true, generateEqual => true,
                generateLessThan => false, useFixedSecodOperand => false, fixedSecodOperand => 0)
    port map(input0 => saidaJ, input1 => saidaK,
            lessThan => open, equal => saidaIgualJK);
			
-- COMPLETE
end architecture;
