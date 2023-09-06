library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binaryCounter is
	generic(	width: positive:= 4;
				generateEnb: boolean := true;
				generateInc: boolean := true;
				generateLoad: boolean := false;
				generateClear: boolean := true;
				clearValue: integer := 0 );
	port(	-- control
			clock, clear, load, enb, inc: in std_logic;
			-- data
			input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0)	);
end entity;

architecture behav0 of binaryCounter is
subtype state is unsigned(width-1 downto 0);
signal nextState, currentState: state;
-- auxiliar
signal tempInc, tempCount, tempEnb, tempLoad, tempClear: state;
begin

    geraInc: if generateInc generate
        tempInc <= currentState+1 when inc='1' else
                     currentState-1;
	 end generate;
    
    naoGeraInc: if not generateInc generate
        tempInc <= currentState-1;
	 end generate;	  
		  
    geraEnable: if generateEnb generate
        tempEnb <= currentState when enb = '0' else
                     tempInc;
	 end generate;
    
    naoGeraEnable: if not generateEnb generate
        tempEnb <= tempInc;
	 end generate;

    geraLoad: if generateLoad generate
        tempLoad <= unsigned(input) when load ='1' else
                     tempEnb;
	 end generate;
    
    naoGeraLoad: if not generateLoad generate
        tempLoad <= tempEnb;
    end generate;

    geraClear: if generateClear generate
        tempClear <= to_unsigned(clearValue, nextState'length) when clear='1' else
                     tempLoad;
	 end generate;
                     
    naoGeraClear: if not generateClear generate
        tempClear <= tempLoad;
	 end generate;

    --logica de proximo estado
    nextState <= tempClear;
    
    --elemento de memoria
    process(clock) is
    begin
        if rising_edge(clock) then
            currentState <= nextState;
        end if;
    end process;
    
    --lógica de saída
    output <= std_logic_vector(currentState);

end architecture;
