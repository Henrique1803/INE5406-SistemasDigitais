--Henrique Mateus Teodoro
library ieee;
use ieee.std_logic_1164.all;

entity example2FSMPedroni is
	port(
		-- control inputs
		clock, reset: in std_logic;
		-- data inputs
		inp: in std_logic;
		-- control outputs
		-- data outputs
		outp: out std_logic_vector(1 downto 0)
	);
end entity;

architecture archstudenttryPg195 of example2FSMPedroni is
	type State is (S1, S2, S3, S4);
	signal currentState, nextState: State;
begin
	-- next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	-- COMPLETE
	process(currentState, inp) is
	begin
		nextState <= currentState;
		
		case currentState is
		
			when S1 =>
					if inp='0' then
						nextState <= S1;
					else
						nextState <= S2;
					end if;
					
			when S2 =>
					if inp='0' then
						nextState <= S3;
					else
						nextState <= S4;
					end if;
						
			when S3 =>
					if inp='0' then
						nextState <= S3;
					else
						nextState <= S4;
					end if;
						
			when S4 =>
					if inp='0' then
						nextState <= S2;
					else
						nextState <= S1;
					end if;
		end case;
		
	end process;
	-- end-next-state logic (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	-- COMPLETE
	process(reset, clock) is
	begin
		if reset = '1' then
			currentState <= S1;
		elsif rising_edge(clock) then
			currentState <= nextState;
		end if;
	end process;
	-- memory register (DO NOT CHANGE OR REMOVE THIS LINE)
	
	
	-- output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
    -- COMPLETE
	 outp <= "00" when currentState = S1 else
				"01" when currentState = S2 else
				"10" when currentState = S3 else
				"11";
    -- end-output-logic (DO NOT CHANGE OR REMOVE THIS LINE)
end architecture;
