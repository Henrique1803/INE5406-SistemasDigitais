library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fibonacciOperatingBlock is
        generic(width: positive);
        port(
            clock, clear: in std_logic;
            ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6, ctrl7, ctrl8, ctrl9: in std_logic;
            stt1, stt2: out std_logic;
            n: in std_logic_vector(width-1 downto 0);
            nterm: out std_logic_vector(width-1 downto 0)
        );
end entity;

architecture structure of fibonacciOperatingBlock is
	component registerN is
	generic(	width: positive;
				generateLoad: boolean := false;
				clearValue: integer := 0 );
	port(	-- control
			clock, clear, load: in std_logic;
			-- data
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0));
	end component;
	
	component addersubtractor is
	generic(	width: positive;
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
	
	component compare is
	generic(	width: positive;
				isSigned: boolean := false;
				generateEqual: boolean := false ;
				generateLessThan: boolean := false;
				useFixedSecodOperand: boolean := false;
				fixedSecodOperand: integer := 0 );
	port(	input0, input1: in std_logic_vector(width-1 downto 0);
			lessThan, equal: out std_logic );
	end component;
	
	component multiplexer2x1 is
	generic(	width: positive );
	port(	input0, input1: in std_logic_vector(width-1 downto 0);
			sel: in std_logic;
			output: out std_logic_vector(width-1 downto 0) );
	end component;
	
	signal i_q, iPlus1, t2_q, t1_q, res_q, mux2res_d, t1PlusT2: std_logic_vector(width-1 downto 0);
	
	signal compLt, compEq, ct8or9: std_logic;
begin
	-- n<=2    ---> stt1

	nLtEq2: compare
	generic map(width => width,
				isSigned => false,
				generateEqual => true,
				generateLessThan => true,
				useFixedSecodOperand => true,
				fixedSecodOperand => 2 )
	port map(input0 => n, input1 => (others=>'X'),
			lessThan => compLt, equal => compEq);
			
	stt1 <= compLt or compEq;
	
	-- i<n       ---> stt2
	
	regI: registerN
	generic map(width => width,
				generateLoad => true,
				clearValue => 3)
	port map(	-- control
			clock => clock, clear => ctrl1, load => ctrl2,
			-- data
			input => iPlus1,
			output => i_q);
	
	nLtN: compare
	generic map(width => width,
				isSigned => false,
				generateEqual => false,
				generateLessThan => true,
				useFixedSecodOperand => false,
				fixedSecodOperand => 0 )
	port map(input0 => i_q, input1 => n,
			lessThan => stt2, equal => open);
	
	-- i=3         ---> ctrl1
    -- i=i+1      ---> ctrl2
			
	addI1: addersubtractor
	generic map(width => width,
			isAdder => true,
			isSubtractor => false,
			generateCout => false,
			generateOvf => false,
			fixedSecodOperand => 1)
	port map(	
		a => i_q, b => (others=>'X'),
		op => 'X',
		result => iPlus1,
		ovf => open, cout => open);
    
	
	--  t1 = 1     ---> ctrl3
	--  t1 = t2    ---> ctrl4 
	
	t1: registerN
	generic map(width => width,
				generateLoad => true,
				clearValue => 1)
	port map(	-- control
			clock => clock, clear => ctrl3, load => ctrl4,
			-- data
			input => t2_q,
			output => t1_q);

	-- t2=1       ---> ctrl5
    -- t2=res    ---> ctrl6
    
    t2: registerN
	generic map(width => width,
				generateLoad => true,
				clearValue => 1)
	port map(	-- control
			clock => clock, clear => ctrl5, load => ctrl6,
			-- data
			input => res_q,
			output => t2_q);
    
	-- res = 1         ---> ctrl7
    -- res = 2         --->  ctrl8
    -- res = t1+t2   --->  ctrl9
    
    res: registerN
	generic map(width => width,
				generateLoad => true,
				clearValue => 1)
	port map(	-- control
			clock => clock, clear => ctrl7, load => ct8or9,
			-- data
			input => mux2res_d,
			output => res_q);
    
    ct8or9 <= ctrl8 or ctrl9;
    
    muxSelRes: multiplexer2x1
	generic map(width => width)
	port map(input0 => t1PlusT2, input1 => (1=>'1', others=>'0'),
			sel => ctrl8,
			output => mux2res_d);
	
	addt1t2: addersubtractor
	generic map(width => width,
			isAdder => true,
			isSubtractor => false,
			generateCout => false,
			generateOvf => false,
			fixedSecodOperand => 0)
	port map(	
		a => t1_q, b => t2_q,
		op => 'X',
		result => t1PlusT2,
		ovf => open, cout => open);
	
	
	nterm <= res_q;
	
end architecture;