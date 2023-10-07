library ieee;
use ieee.std_logic_1164.all;

entity sd_sad is
	generic(
		datawidth: positive:=8;
		addresswidth: positive:=6);
	port(
		-- control in
		ck, reset, iniciar: in std_logic;
		-- data in
		pA, pB: in std_logic_vector(datawidth-1 downto 0);
		-- controll out
		ender: out std_logic_vector(addresswidth-1 downto 0);
		readmem, pronto: out std_logic;
		sad: out std_logic_vector(datawidth+addresswidth-1 downto 0)
	);
end entity;

architecture archstruct of sd_sad is
-- COMPLETE

component blococontrole_sad is
	port(
		-- control in
		ck, reset, iniciar, 
		menor : in std_logic;
		-- data in
		-- controll out
		zi, ci, cpA, cpB, zsoma, csoma, csad_reg, 
		readmem, pronto: out std_logic
		-- data out
	);
end component;

component blocooperativo_sad is
	generic(
		datawidth: positive;
		addresswidth: positive);
	port(
		-- control in
		ck, reset, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : in std_logic;
		-- data in
		pA, pB: in std_logic_vector(datawidth-1 downto 0);
		-- controll out
		ender: out std_logic_vector(addresswidth-1 downto 0);
		menor: out std_logic;
		sad: out std_logic_vector(datawidth+addresswidth-1 downto 0)
	);
end component;

signal zi, ci, cpA, cpB, zsoma, csoma, csad_reg, menor: std_logic;

begin

   blocoDeControleSad: blococontrole_sad
		port map(ck, reset, iniciar, menor, zi, ci, cpA, cpB, zsoma, csoma, csad_reg, 
			readmem, pronto);
	
	blocoOperativoSad: blocooperativo_sad
		generic map(
			datawidth, addresswidth)
		port map( ck, reset, zi, ci, cpA, cpB, zsoma, csoma, csad_reg,
			     pA, pB, ender, menor, sad);
	 
end architecture;


