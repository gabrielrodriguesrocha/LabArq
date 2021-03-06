-- control module
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY control IS
   PORT( Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			RegDst 		: OUT STD_LOGIC;
			RegWrite 	: OUT STD_LOGIC;
			ALUSrc		: OUT STD_LOGIC;
			MemToReg		: OUT STD_LOGIC;
			MemRead		: OUT STD_LOGIC;
			MemWrite		: OUT STD_LOGIC);
			-- *** Acrescentar a linha abaixo a sua unidade para selecionar as operações
			-- Será mapeado para o execute
			ALUOp 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ));
END control;

ARCHITECTURE behavior OF control IS

SIGNAL R_format 	: STD_LOGIC;
SIGNAL SW			: STD_LOGIC;
SIGNAL LW			: STD_LOGIC;

BEGIN
	-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000" ELSE '0';
  	SW				<=  '1' 	WHEN  Opcode = "101011" ELSE '0';
	LW				<=  '1' 	WHEN  Opcode = "100011" ELSE '0';
	
	RegDst    	<=  R_format;
  	RegWrite 	<=  R_format OR LW;
	ALUSrc		<=	 LW OR SW;
	MemToReg		<=  LW;
	MemRead		<=  LW;
	MemWrite		<=  SW;

	-- *** ACRECENTE AS ATRIBUIÇÕES ABAIXO
	ALUOp( 1 ) 	<=  R_format;
	ALUOp( 0 ) 	<=  Beq; -- Beq deve ser 1 quando a instrução for BEQ
	
END behavior;


