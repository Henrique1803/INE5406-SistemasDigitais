-- Complete abaixo com o nome dos alunos que fazem esta avaliacao (sem caracteres especiais nos nomes, como acentos)
-- ALUNO 1: Henrique Mateus Teodoro
-- ALUNO 2:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity arbitraryCounter is
	generic(min: natural;
	        max: natural;
	        step: natural;
			generateLoad: boolean;
			generateEnb: boolean;
			generateInc: boolean);
	port(	-- control
			clock, reset, load: in std_logic;
			enb, inc: in std_logic;
			-- data
			input: in std_logic_vector(integer(ceil(log2(real(max))))-1 downto 0);
			output: out std_logic_vector(integer(ceil(log2(real(max))))-1 downto 0)	);
	begin
		assert min<max report "Min should be smaller than max" severity error;
		assert step<(max-min) report "Step should be smaller than the max-min interval" severity error;
end entity;


architecture behav0 of arbitraryCounter is
    -- Nao altere as duas linhas abaixo
    subtype state is unsigned(integer(ceil(log2(real(max))))-1 downto 0);
    signal nextState, currentState: state;
	 signal tempLoad, tempEnb, tempInc, tempAux: state;
    -- COMPLETE AQUI, SE NECESSARIO
begin
	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	geraInc: if generateInc generate
        tempAux <= currentState+step when inc='1' else
                    currentState-step;
	    tempInc <= tempAux when to_integer(tempAux) <= max and to_integer(tempAux) >= min else
				   to_unsigned(min, tempInc'length) when to_integer(tempAux) > max else
				   to_unsigned(max, tempInc'length);
	    
	 end generate;
    
    naoGeraInc: if not generateInc generate
        tempAux <= currentState+step;
		tempInc <= tempAux when to_integer(tempAux) <= max else
				  to_unsigned(min, tempInc'length);
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
			currentState <= to_unsigned(min, currentState'length);
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