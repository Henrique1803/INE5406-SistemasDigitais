-- COMPLETE COM O NOME COMPLETO DOS ALUNOS QUE FAZEM ESTA AVALIACAO
-- Aluno 1: Henrique Mateus Teodoro
-- Aluno 2:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifterRotator is
	generic(
		width: positive;
		isShifter: boolean;
		isLogical: boolean;
		toLeft: boolean;
		bitsToShift: positive
	);
	port(
		input: in std_logic_vector(width-1 downto 0);
		output: out std_logic_vector(width-1 downto 0)
	);
	begin
		assert (bitsToShift < width) severity error;
end entity;

architecture behav of shifterRotator is
	 
begin


    deslocador: if isShifter generate 
    
        logico: if isLogical generate
            output <= std_logic_vector(shift_left(unsigned(input), bitsToShift)) when toLeft else
				std_logic_vector(shift_right(unsigned(input), bitsToShift));
        end generate ; 
        
        aritmetico: if not isLogical generate
            output <= std_logic_vector(shift_left(signed(input), bitsToShift)) when toLeft else
				std_logic_vector(shift_right(signed(input), bitsToShift));
        end generate ;
        
    end generate;
	 
	 rotacionador: if not isShifter generate 
    
        output <= std_logic_vector(rotate_left(unsigned(input), bitsToShift)) when toLeft else
				std_logic_vector(rotate_right(unsigned(input), bitsToShift));
        
    end generate;
	 
	 
end architecture; 