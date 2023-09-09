-- Complete abaixo com o nome dos alunos que fazem esta avaliacao (sem caracteres especiais nos nomes, como acentos)
-- ALUNO 1: Henrique Mateus Teodoro
-- ALUNO 2:

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity moduleCounter is
	generic(	module: positive := 60;
				generateLoad: boolean := true;
				generateEnb: boolean := true;
				generateInc: boolean := true;
				resetValue: integer := 0 );
	port(	-- control
			clock, reset: in std_logic;
			load, enb, inc: in std_logic;
			-- data
			input: in std_logic_vector(integer(ceil(log2(real(module))))-1 downto 0);
			output: out std_logic_vector(integer(ceil(log2(real(module))))-1 downto 0)	);
end entity;


architecture behav0 of moduleCounter is
    -- Nao altere as duas linhas abaixo
    subtype state is unsigned(integer(ceil(log2(real(module))))-1 downto 0);
    signal nextState, currentState: state;
	 signal tempLoad, tempEnb, tempInc: state;
	 signal tempAux: integer;
    -- COMPLETE AQUI, SE NECESSARIO
begin
	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	-- COMPLETE
	geraInc: if generateInc generate
        tempAux <= to_integer(currentState)+1 when inc='1' else
                    to_integer(currentState)-1;
	    tempInc <= to_unsigned(tempAux, tempInc'length) when tempAux <= module-1 and tempAux >= 0 else
	               to_unsigned(module-1, tempInc'length) when tempAux < 0 else
				   to_unsigned(0, tempInc'length);
	    
	 end generate;
    
    naoGeraInc: if not generateInc generate
        tempAux <= to_integer(currentState)+1;
		tempInc <= to_unsigned(tempAux, tempInc'length) when tempAux <= module-1 and tempAux >= 0 else
	               to_unsigned(module-1, tempInc'length) when tempAux < 0 else
				   to_unsigned(0, tempInc'length);
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

    nextState <= tempLoad;
	-- end-next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	process(clock, reset) is
	begin
		if reset='1' then
			currentState <= (to_unsigned(resetValue, currentState'length));
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
    -- COMPLETE
	 output <= std_logic_vector(currentState);
    -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
end architecture;