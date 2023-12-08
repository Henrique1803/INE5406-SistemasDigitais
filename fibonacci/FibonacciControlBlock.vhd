library ieee;
use ieee.std_logic_1164.all;

entity  fibonacciControlBlock is
        port(
            clock, clear: in std_logic;
            ctrl1, ctrl2, ctrl3, ctrl4, ctrl5, ctrl6, ctrl7, ctrl8, ctrl9: out std_logic;
            stt1, stt2: in std_logic;
			iniciar: in std_logic;
			pronto: out std_logic
        );
end entity;

architecture BC of fibonacciControlBlock is
	type State is (L01, L02, L03, L04, L06, L07, L08, L09, L10, L11, L12, L13, L14);
	signal currentState, nextState: State;
begin
	-- NextState Logic
	--
	process(currentState, stt1, stt2, iniciar) is
	begin
	
	    nextState <= L01;
	    
	    CASE currentState is

	 -- L01: unsigned int Fibonacci(unsigned int n) {
	    when L01 =>
	                if iniciar = '1' then
	                    nextState <= L02;
	                else
	                    nextState <= L01;
	                end if;
	-- L02: unsigned int res, i, t1, t2;  // declarations only
	    when L02 =>
	               nextState <= L03;
	-- L03: if (n <= 2)
	    when L03 =>
	                if stt1 = '1' then
	                    nextState <= L04;
	                else
	                    nextState <= L06;
	                end if;
	-- L04:     res=1;
	    when L04 =>
	               nextState <= L01;
	-- L05: else
	-- L06:      t1 = 1;
	     when L06 =>
	               nextState <= L07;
	-- L07:      t2 = 1;
	     when L07 =>
	               nextState <= L08;
	-- L08:      res = 2;
	     when L08 =>
	               nextState <= L09;
	-- L09:      i=3;
	     when L09 =>
	               nextState <= L10;
	-- L10:      while (i<n)
	    when L10 =>
	                if stt2 = '1' then
	                    nextState <= L11;
	                else
	                    nextState <= L01;
	                end if;
	-- L11:            t1 = t2;
	    when L11 =>
	               nextState <= L12;
	-- L12:            t2 = res;
	    when L12 =>
	               nextState <= L13;
	-- L13:            res = t1+t2;
	    when L13 =>
	               nextState <= L14;
	-- L14:            i = i+1;
	    when L14 =>
	               nextState <= L10;
	-- L15: return res;
	    
	    end case;
	
	end process;
	--

	
	-- State Register
	process(clock, clear) is
	begin
		if clear='1' then
				currentState <= L01;
		elsif rising_edge(clock) then
				currentState <= nextState;
		end if;
	end process;
	
	-- Output Logic
	--
	-- COMPLETE
	--
	-- L01: unsigned int Fibonacci(unsigned int n) {
	-- L02: unsigned int res, i, t1, t2;  // declarations only
	-- L03: if (n <= 2)
	-- L04:     res=1;
	-- L05: else
	-- L06:      t1 = 1;
	-- L07:      t2 = 1;
	-- L08:      res = 2;
	-- L09:      i=3;
	-- L10:      while (i<n)
	-- L11:            t1 = t2;
	-- L12:            t2 = res;
	-- L13:            res = t1+t2;      
	-- L14:            i = i+1;
	-- L15: return res;
	-- n<=2    ---> stt1
	-- i<n       ---> stt2
	-- i=3         ---> ctrl1
	ctrl1 <= '1' when currentState = L09 else '0';
    -- i=i+1      ---> ctrl2
    ctrl2 <= '1' when currentState = L14 else '0';
	--  t1 = 1     ---> ctrl3
	ctrl3 <= '1' when currentState = L06 else '0';
	--  t1 = t2    ---> ctrl4 
	ctrl4 <= '1' when currentState = L11 else '0';
	-- t2=1       ---> ctrl5
	ctrl5 <= '1' when currentState = L07 else '0';
    -- t2=res    ---> ctrl6
    ctrl6 <= '1' when currentState = L12 else '0';
	-- res = 1         ---> ctrl7
	ctrl7 <= '1' when currentState = L04 else '0';
    -- res = 2         --->  ctrl8
    ctrl8 <= '1' when currentState = L08 else '0';
    -- res = t1+t2   --->  ctrl9
    ctrl9 <= '1' when currentState = L13 else '0';
    
    pronto <= '1' when currentState = L01 else '0';
    
    
end architecture;