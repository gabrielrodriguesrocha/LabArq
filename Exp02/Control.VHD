-- control module
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY control IS
   PORT( Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			RegDst 		: OUT 	STD_LOGIC;
			RegWrite 	: OUT 	STD_LOGIC);
END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format 	: STD_LOGIC;

BEGIN           
	R_format <= '1' WHEN Opcode = "000000" ELSE '0';
	
	RegDst <= R_format;
	RegWrite <= R_format;

   END behavior;


