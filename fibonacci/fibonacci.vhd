-----------------------------------------------------------------------------------------------------------------
-- COMPLETE COM O NOME COMPLETO DOS ALUNOS QUE REALIZAM ESTA AVALIACAO (NAO USE ACENTOS OU CARACTERES ESPECIAIS)
-- ALUNO 1: Henrique Mateus Teodoro
-- ALUNO 2:
-----------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity fibonacci is
    generic(width: positive := 16);
    port(
		-- control inputs
        clock, clear: in std_logic;
		iniciar: in std_logic;
		-- control outputs
		pronto: out std_logic;
		-- data inputs
        n: in std_logic_vector(width-1 downto 0);
		-- data outputs
        nterm: out std_logic_vector(width-1 downto 0)
    );
end entity;

architecture structure of fibonacci is
    component fibonacciControlBlock is
        port(
            clock, clear: in std_logic;
            ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6, ctrl7, ctrl8, ctrl9: out std_logic;
            stt1, stt2: in std_logic;
			iniciar: in std_logic;
			pronto: out std_logic
        );
    end component;
    
    component fibonacciOperatingBlock is
        generic(width: positive);
        port(
            clock, clear: in std_logic;
            ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6, ctrl7, ctrl8, ctrl9: in std_logic;
            stt1, stt2: out std_logic;
            n: in std_logic_vector(width-1 downto 0);
            nterm: out std_logic_vector(width-1 downto 0)
        );
    end component;

    signal  ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6, ctrl7, ctrl8, ctrl9, stt1, stt2: std_logic;
begin
    BC:fibonacciControlBlock
        port map(
            clock, clear,
            ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6, ctrl7, ctrl8, ctrl9,
            stt1, stt2,
			iniciar,
			pronto
        );
    
    
    
    BO: fibonacciOperatingBlock
        generic map(width)
        port map(
            clock, clear,
            ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6, ctrl7, ctrl8, ctrl9,
            stt1, stt2,
            n,
            nterm
        );

end architecture;