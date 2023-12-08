library ieee;
use ieee.std_logic_1164.all;

entity blocoControle is
	port (
				--Entradas de controle:
				clock, iniciar: in std_logic;
				--Saídas de controle:
				retorno: out std_logic;
				
				ctrlSetaResto, ctrlSetaQuocienteEmZero, ctrlSetaRestoMenosDivisor, ctrlSetaQuocienteMaisUm: out std_logic;
				sttRestoMaiorIgualDivisor: in std_logic
            );
end entity;

architecture SD of blocoControle is
	type State is (L01, L02, L03, L04, L05, L06, L08);
	signal currentState, nextState: State;

begin

--lógica de próximo estado
process(currentState, iniciar, sttRestoMaiorIgualDivisor) is
begin

	nextState <= currentState;
	
	case currentState is
	
	when L01 =>
		if iniciar = '0' then
			nextState <= L01;
		else
			nextState <= L02;
		end if;
		
	when L02 =>
		nextState <= L03;
	
	when L03 =>
		nextState <= L04;
	
	when L04 =>
		if sttRestoMaiorIgualDivisor = '0' then
			nextState <= L08;
		else
			nextState <= L05;
		end if;
	
	when L05 =>
		nextState <= L06;
		
	when L06 =>
		nextState <= L04;
	
	when L08 =>
		nextState <= L01;
	
	end case;
	
end process;

--elemento de memória
process(clock) is
begin
	if rising_edge(clock) then
		currentState <= nextState;
	end if;
end process;

--lógica de saída

retorno <= '1' when currentState = L08 or currentState=L01 else '0';
ctrlSetaResto <= '1' when currentState = L02 else '0';
ctrlSetaQuocienteEmZero <= '1' when currentState = L03 else '0';
ctrlSetaRestoMenosDivisor <= '1' when currentState = L05 else '0';
ctrlSetaQuocienteMaisUm <= '1' when currentState = L06 else '0'; 


end architecture;
            
