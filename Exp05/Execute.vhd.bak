LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Execute IS
	PORT( Read_data1 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Read_data2 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			PC				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			ALU_Result 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			Signal_Ext 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Alu_Src		: IN STD_LOGIC;
			Zero			: OUT STD_LOGIC;
			ADDResult 	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END Execute;

ARCHITECTURE behavior OF Execute IS
	SIGNAL iAux : STD_LOGIC_VECTOR(31 DOWNTO 0);
	BEGIN
	
	iAux <= Read_data2 WHEN Alu_src = '0' ELSE Signal_Ext;
	ALU_Result <= Read_data1 + iAux;
	
	Zero <= '0' WHEN (Read_data1 /= Read_data2) ELSE '1';
	
	ADDResult <= PC + 1 + Signal_Ext (7 DOWNTO 0);
	
	--- multiplex ---
END behavior;
