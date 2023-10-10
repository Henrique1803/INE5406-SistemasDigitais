library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compare is
	generic(	width: positive;
				isSigned: boolean;
				generateLessThan: boolean;
				generateEqual: boolean );
	port(	input0, input1: in std_logic_vector(width-1 downto 0);
			lessThan, equal: out std_logic );
	begin
		assert (generateLessThan or generateEqual) report "Pelo menos uma das saídas deve ser gerada" severity error;		
end entity;

architecture behav0 of compare is
    signal temp: integer;
begin

    geraMenorQue: if generateLessThan generate 
    
        com_sinal: if isSigned generate
            temp <= to_integer(signed(input0)) - to_integer(signed(input1));
        end generate ; 
        
        sem_sinal: if not isSigned generate
            temp <= to_integer(unsigned(input0)) - to_integer(unsigned(input1));
        end generate ;
        
        lessThan <= '1' when temp < 0 else '0';
        
    end generate;
     
    
    gerarIgual: if generateEqual generate
    
        equal <= '1' when input0 = input1 else '0';
        
    end generate ; 
    

end architecture;