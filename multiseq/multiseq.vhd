library ieee;
use ieee.std_logic_1164.all;

entity multiseq is
	generic(largura: positive := 8);
	port(
		-- control in
		ck, Reset, iniciar: in std_logic;
		-- control out
		pronto: out std_logic;
		-- data in
		entA, entB: in std_logic_vector(largura-1 downto 0);
		-- data out
		mult: out std_logic_vector(largura-1 downto 0)
	);
end entity;

architecture descricaoEstrutural of multiseq is


component bo is
	generic(largura: positive);
	port(
		-- control in
		ck, Reset: in std_logic;
		mP, cP, mA, cA, cB, cmult, m1, m2, op: in std_logic;
		-- control out
		Az, Bz: out std_logic;
		-- data in
		entA, entB: in std_logic_vector(largura-1 downto 0);
		-- data out
		mult: out std_logic_vector(largura-1 downto 0)
	);
end component;

component bc is
	generic(largura: positive);
	port(
		-- control in
		ck, Reset, iniciar: in std_logic;
		Az, Bz: in std_logic;
		-- control out
		mP, cP, mA, cA, cB, cmult, m1, m2, op: buffer std_logic;
		pronto: out std_logic
		-- data in
		-- data out
	);
end component;

	signal mP, cP, mA, cA, cB, cmult, m1, m2, op, Az, Bz: std_logic;

begin
    -- COMPLETE COM COMANDOS CONCORRENTES 
	 
	 
	blocoOp: bo
		generic map(largura => largura)
		port map(ck => ck, Reset => Reset, mP => mP, cP => cP, mA => mA, cA => cA, cB => cB, cmult => cmult, m1 => m1, m2 => m2, op => op,
			      Az => Az, Bz => Bz, entA => entA, entB => entB, mult => mult);

	 
	blocoControle: bc
	generic map(largura => largura)
	port map(ck => ck, Reset => Reset, iniciar => iniciar,
		Az => Az, Bz => Bz, mP => mP, cP => cP, mA => mA, cA => cA, cB => cB, cmult => cmult, m1=>m1, m2=>m2, op=>op, pronto=> pronto);

	 
end architecture;
