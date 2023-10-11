library ieee;
use ieee.std_logic_1164.all;

entity blococontrole_sad is
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
end entity;

architecture archbehav of blococontrole_sad is
	type State is (S0, S1, S2, S3, S4, S5);
	signal currentState, nextState: State;
-- COMPLETE
begin
    -- logica de proximo estado
    -- COMPLETE
	 process(currentState, iniciar, menor) is
	 begin
		
		nextState <= currentState;
		
		case currentState is
		
			when S0 => 
						 if iniciar = '0' then
							nextState <= S0;
						 else
							nextState <= S1;
						 end if;
			
			when S1 => 
						 nextState <= S2;
			
			when S2 => 
						 if menor = '1' then
							nextState <= S3;
						 else
							nextState <= S5;
						 end if;
			when S3 => 
						 nextState <= S4;
			
			when S4 => 
						 nextState <= S2;
			
			when S5 => 
						 nextState <= S0;
		
		end case;
	 
	 end process;
    
    -- regitrador de estado
	 process(reset, ck) is
	 begin
		if reset = '1' then
			currentState <= S0;
		elsif rising_edge(ck) then
			currentState <= nextState;
		end if;
	 end process;
    -- COMPLETE
    
    -- logica de saida
    -- COMPLETE
	 
	 pronto <= '1' when currentState = S0 else '0';
	 readmem <= '1' when currentState = S3 else '0';
	 zi <= '1' when currentState = S1 else '0';
	 ci <= '1' when (currentState = S1 or currentState = S4) else '0';
	 cpA <= '1' when currentState = S3 else '0';
	 cpB <= '1' when currentState = S3 else '0';
	 zsoma <= '1' when currentState = S1 else '0';
	 csoma <= '1' when (currentState = S1 or currentState = S4) else '0';
	 csad_reg <= '1' when currentState = S5 else '0';
	 
	 
end architecture;
