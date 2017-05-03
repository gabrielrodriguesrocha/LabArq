-- control module
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY control IS
   PORT( Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			RegDst 		: OUT STD_LOGIC;
			RegWrite 	: OUT STD_LOGIC;
			MemToReg 	: OUT STD_LOGIC;
			MemRead 		: OUT STD_LOGIC;
			MemWrite 	: OUT STD_LOGIC;
			AluSrc		: OUT STD_LOGIC);
END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  	R_format : STD_LOGIC;
	SIGNAL	I_format : STD_LOGIC;
	SIGNAL	J_format : STD_LOGIC;

BEGIN           
	R_format <= '1' WHEN Opcode = "000000" ELSE '0';
	I_format <= '1' WHEN Opcode = "100011" ELSE --LOAD
					'1' WHEN Opcode = "101011" ELSE --STORE
					'1' WHEN Opcode = X"4"	ELSE --BEQ
					'1' WHEN Opcode = X"5"	ELSE --BNEQ
					'1' WHEN Opcode = X"8"	ELSE'0'; --ADDI
					
	RegDst   <= R_format;
	RegWrite <= '1' WHEN R_format = '1' ELSE
					'1' WHEN Opcode = "100011" ELSE
					'0';
	
	MemWrite <= '1' WHEN Opcode = "101011" ELSE '0'; --Store
	MemRead  <= '0' WHEN Opcode = "101011" ELSE '1'; 
	MemToReg <= '1' WHEN Opcode = "100011" ELSE '0'; --Load
	AluSrc   <= I_Format;
	
   END behavior;


