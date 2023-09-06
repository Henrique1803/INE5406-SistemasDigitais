-- COMPLETE COM O NOME COMPLETO DOS ALUNOS QUE FAZEM ESTA AVALIACAO
-- Aluno 1: Henrique Mateus Teodoro

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity binaryEncoder is
	generic(inputWidth: positive;
			priorityMSB: boolean;
			generateValid: boolean );
	port(input: in std_logic_vector(inputWidth-1 downto 0);
		valid: out std_logic;
		output: out std_logic_vector(integer(ceil(log2(real(inputWidth))))-1 downto 0) );
end entity;

architecture behav0 of binaryEncoder is

begin

    process(input)
	variable temp: integer;
	begin
		
		temp := 0;
	
		if priorityMSB then
			for i in inputWidth-1 downto 0 loop 
				if input(i) = '1' then
					temp := i;
					exit;
				end if;
			end loop;
		else
			for i in 0 to inputWidth-1 loop 
				if input(i) = '1' then
					temp := i;
					exit;
				end if;
			end loop;
		end if;
		
		output <= std_logic_vector(to_unsigned(temp, output'length));
	
	end process;
	
	
	gerarValido: if generateValid generate
		valid <= '1' when to_integer(unsigned(input)) > 0 else
        '0';
	end generate;

end architecture;
