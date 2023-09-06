library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity bitsCombCounter is
	generic(
	    N: positive;
        count1s: boolean := true
	);
	port(   
	    input: in std_logic_vector(N-1 downto 0);
		output: out std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) 
	);
end entity;

architecture sequential_behavour_thats_a_hint of bitsCombCounter is
-- complete
begin

	process(input)
		variable cont : integer;
	begin
		cont := 0;
		if count1s then
			for i in N-1 downto 0 loop
				if input(i) = '1' then
					cont := cont + 1;
				end if;
			end loop;
		else	
			for i in N-1 downto 0 loop
				if input(i) = '0' then
					cont := cont + 1;
				end if;
			end loop;
		end if;
	
		output <= std_logic_vector(to_unsigned(cont, output'length));
	
	end process;



end architecture;