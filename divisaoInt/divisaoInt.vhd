-- PROJETO DE SISTEMA DIGITAL

-- 1. Descrever a funcionalide
--
-- Fazer um sistema que receba um dividendo e um divisor de N bits e
-- devolva o quociente o ersto da divisao deles

-- 2. Capturar o comportamento por um algoritmo (codigo-fonte)
--
-- L01: [quociente, resto] = divisotInt(unsigned int dividendo, unsigned int divisor) {
-- L02: unsigned int resto = dividendo;
-- L03: unsigned int quociente = 0;
-- L04: while (resto >= divisor) {
-- L05:    resto = resto - divisor;
-- L06:    quociente = quociente + 1;
-- L07: }
-- L08: return quociente, resto;

-- 3. Especificar as entradas e saidas
--
-- Entrada de dados
--   unsigned int dividendo (largDividendo bits), divisor (largDivisor bits)
-- Saida de dados:
--   unsigned int quociente (largDividendo bits), resto ((largDivisor bits))
-- Entradas de controle:
--     bit iniciar, bit clock
-- Saidas de controle:
--     bit retorno
--
-- 4. Especificar os dados e operaçoes sobre eles
-- L02: resto = dividendo                  --> ctrlSetaResto
-- L03: quociente = 0;                     --> ctrlSetaQuocienteEmZero
-- L04: resto >= divisor                   --> sttRestoMaiorIgualDivisor
-- L05: resto = resto - divisor;           --> ctrlSetaRestoMenosDivisor
-- L06: quociente = quociente + 1;         --> ctrlSetaQuocienteMaisUm
--
-- 5. Capturar o comportamento (e estrutura) do algoritmo por uma FSMD
--
-- 5.1 Diagrama de Transicao (Logica de proximo estado)

-- L01: [quociente, resto] = divisotInt(unsigned int dividendo, unsigned int divisor) {
-- 	L01 [!iniciar] -> L01 / [iniciar]-> L02
-- L02: unsigned int resto = dividendo;
-- 	L02 -> L03
-- L03: unsigned int quociente = 0;
-- 	L03 -> L04
-- L04: while (resto >= divisor) {
-- 	L04 [!sttRestoMaiorIgualDivisor] -> L08 / [sttRestoMaiorIgualDivisor]-> L05
-- L05:    resto = resto - divisor;
-- 	L05 -> L06
-- L06:    quociente = quociente + 1;
-- 	L06 -> L04
-- L08: return quociente, resto;
-- 	L08 -> L01

--
-- 5.2 Diagrama de saida (logica de saida)
-- L01: [quociente, resto] = divisotInt(unsigned int dividendo, unsigned int divisor) {
--		retorno
-- L02: unsigned int resto = dividendo;
--		ctrlSetaResto
-- L03: unsigned int quociente = 0;
--		ctrlSetaQuocienteEmZero
-- L04: while (resto >= divisor) {
-- L05:    resto = resto - divisor;
--		ctrlSetaRestoMenosDivisor
-- L06:    quociente = quociente + 1;
--		ctrlSetaQuocienteMaisUm
-- L07: }
-- L08: return quociente, resto;
--		retorno

-- 6. Projeto de Bloco Operativo


--6.1 Circuitos Combinacionais
--   L04: resto >= divisor             -> comparador de maior ou igual
--   L05: resto = resto - divisor;     -> subtrator e mux2x1
--   L06: quociente = quociente + 1;   -> somador

--6.2 Circuitos Sequenciais
--   L02: resto = dividendo;        -> registrador D com load
--   L03: quociente = 0;            -> registrador D com clear e load
--
-- Continuar fazendo o esquematico que envolve todos os circuitos acima e eventualmente mais alguns
--
-- 7. Refinamento da FSMD para formar o bloco de controle
--
-- 7.1 Identificar se algum sinal de controle de status pode ser removido e fazer as mudanças
--
--


library ieee;
use ieee.std_logic_1164.all;

entity divisaoInt is
    generic(largDividendo: integer:=8;
            largDivisor: integer:=8);
    port (
				--Entradas de controle:
				clock, iniciar: in std_logic;
				--Saídas de controle:
				retorno: out std_logic;
				--Entrada de dados:
            dividendo: in std_logic_vector(largDividendo-1 downto 0);
            divisor: in std_logic_vector(largDivisor-1 downto 0);
				--Saída de dados:
            quociente: out std_logic_vector(largDividendo-1 downto 0);
            resto: out std_logic_vector(largDivisor-1 downto 0)
            );
end entity;

architecture SD of divisaoInt is


component blocoControle is
	port (
				--Entradas de controle:
				clock, iniciar: in std_logic;
				--Saídas de controle:
				retorno: out std_logic;
				
				ctrlSetaResto, ctrlSetaQuocienteEmZero, ctrlSetaRestoMenosDivisor, ctrlSetaQuocienteMaisUm: out std_logic;
				sttRestoMaiorIgualDivisor: in std_logic
            );
end component;

component blocoOperativo is
	generic(largDividendo: integer;
            largDivisor: integer);
	port (	
				clock: in std_logic;
				--Entrada de dados:
            dividendo: in std_logic_vector(largDividendo-1 downto 0);
            divisor: in std_logic_vector(largDivisor-1 downto 0);
				--Saída de dados:
            quociente: out std_logic_vector(largDividendo-1 downto 0);
            resto: out std_logic_vector(largDivisor-1 downto 0);
				
				ctrlSetaResto, ctrlSetaQuocienteEmZero, ctrlSetaRestoMenosDivisor, ctrlSetaQuocienteMaisUm: in std_logic;
				sttRestoMaiorIgualDivisor: out std_logic
            );
end component;

signal ctrlSetaResto, ctrlSetaQuocienteEmZero, ctrlSetaRestoMenosDivisor, ctrlSetaQuocienteMaisUm, sttRestoMaiorIgualDivisor: std_logic;

begin

 bc: blocoControle
	port map(clock, iniciar, retorno, ctrlSetaResto, ctrlSetaQuocienteEmZero, ctrlSetaRestoMenosDivisor, ctrlSetaQuocienteMaisUm, sttRestoMaiorIgualDivisor
   );

 bo: blocoOperativo
	generic map(largDividendo, largDivisor)
	port map(clock, dividendo, divisor, quociente, resto, ctrlSetaResto,
				ctrlSetaQuocienteEmZero, ctrlSetaRestoMenosDivisor, ctrlSetaQuocienteMaisUm, sttRestoMaiorIgualDivisor
            );

end architecture;
            
