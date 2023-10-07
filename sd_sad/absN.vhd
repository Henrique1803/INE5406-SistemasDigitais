library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity absN is
	generic(	width: positive := 8 );
	port(	input: in std_logic_vector(width-1 downto 0);
			output: out std_logic_vector(width-1 downto 0) );
end entity;

architecture behav0 of absN is
begin
    -- COMPLETE COM COMANDOS CONCORRENTES
	 
	 output <= std_logic_vector(abs(signed(input)));
	 
end architecture;