library ieee;
use ieee.std_logic_1164.all; 
use ieee.math_real.all;
--arch
use ieee.numeric_std.all;

-- Estudante: Henrique Mateus Teodoro

entity dataAddress is
	generic(	
	    addressWidth: positive:=8;
		dataWidth: positive := 8;   -- in bits ; dataNumBytes = dataWidth/8 
		isVector: boolean := false; -- vector is a column matrix; vector[column] = matrix[0,column]
		isMatrix: boolean := false; -- matrix[row,column]
		numRowElements: positive := 1;  
		numColumnElements: positive := 1
	);
	port(
	    baseaddress: in std_logic_vector(addresswidth-1 downto 0);
	    row: in std_logic_vector(integer(ceil(log2(real(numRowElements))))-1 downto 0);        -- used only of data is in a matrix (0-based)
	    column: in std_logic_vector(integer(ceil(log2(real(numColumnElements))))-1 downto 0);  -- used only if data is in vector or matrix (0-based)
	    byteToAccess: in std_logic_vector(integer(ceil(log2(real(dataWidth)/8.0)))-1 downto 0);    -- if dataWidt>8 (1 byte) this the number of the byte to access (0<= byeToAccess <= dataNumBytes)
		address: out std_logic_vector(addressWidth-1 downto 0) 
	);
	begin
	    assert not (isVector and isMatrix) report "Data can not be a vector and a matrix at the same time" severity error;
end entity;

architecture youdecide of dataAddress is
	constant dataNumBytes: positive := integer(ceil(real(dataWidth)/8.0));
    signal endereco_inteiro, row_inteiro, column_inteiro, byteToAccess_inteiro, baseaddress_inteiro: integer:=0;

    -- COMPLETE	
begin
	-- general formula for all:  baseaddress + dataNumBytes * (row * numColumnElements + column) + byteToAccess
	row_inteiro <= to_integer(unsigned(row));
	column_inteiro <= to_integer(unsigned(column));
	byteToAccess_inteiro <= to_integer(unsigned(byteToAccess));
	baseaddress_inteiro <= to_integer(unsigned(baseaddress));

	-- Same formula simplified for variables with dataNumBytes = 1:  baseaddress
	caso1: if (not isVector) and (not isMatrix) and (dataNumBytes = 1) generate
	    endereco_inteiro <= baseaddress_inteiro;
	end generate;
	-- Same formula simplified for variables with dataNumBytes > 1:  baseaddress + byteToAccess
	caso2: if (not isVector) and (not isMatrix) and (dataNumBytes > 1) generate
	    endereco_inteiro <= baseaddress_inteiro + byteToAccess_inteiro;
	end generate;

	-- Same formula simplified for vectors with dataNumBytes = 1:  baseaddress + column
	caso3: if isVector and (not isMatrix) and (dataNumBytes = 1) generate
	    endereco_inteiro <= baseaddress_inteiro + column_inteiro;
	end generate;
	-- Same formula simplified for vectors with dataNumBytes > 1:  baseaddress + dataNumBytes*column + byteToAccess
    caso4: if isVector and (not isMatrix) and (dataNumBytes > 1) generate
	    endereco_inteiro <= baseaddress_inteiro + (dataNumBytes*column_inteiro) + byteToAccess_inteiro;
	end generate;
	
	-- Same formula simplified for matrixes with dataNumBytes = 1:  baseaddress + row*numColumnElements + column
	caso5: if (not isVector) and isMatrix and (dataNumBytes = 1) generate
	    endereco_inteiro <= baseaddress_inteiro + (row_inteiro*numColumnElements) + column_inteiro;
	end generate;
	-- Same formula simplified for matrixes with dataNumBytes > 1:  baseaddress + dataNumBytes*row*numColumnElements + dataNumBytes*column + byteToAccess
	caso6: if (not isVector) and isMatrix and (dataNumBytes > 1) generate
	    endereco_inteiro <= baseaddress_inteiro + (dataNumBytes*row_inteiro*numColumnElements) + dataNumBytes*column_inteiro + byteToAccess_inteiro;
	end generate;
	
	-- vector is the same as matrix[0, column]
	-- variable is the same as matrix[0, 0]	
    address <= std_logic_vector(to_unsigned(endereco_inteiro, address'length));
    
    -- COMPLETE	
end architecture;





