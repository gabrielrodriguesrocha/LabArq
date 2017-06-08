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
			AluSrc		: OUT STD_LOGIC;
			Branch		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			Jump			: OUT STD_LOGIC;
			Link			: OUT STD_LOGIC;
			AluOp			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  	R_format : STD_LOGIC;
	SIGNAL	I_format : STD_LOGIC;
	SIGNAL	J_format : STD_LOGIC;

BEGIN           
	R_format <= '1' WHEN Opcode = "000000" ELSE '0';
	I_format <= '1' WHEN Opcode = "100011" ELSE --LOAD
					'1' WHEN Opcode = "101011" ELSE --STORE
					'1' WHEN Opcode = "000100"	ELSE --BEQ
					'1' WHEN Opcode = "000101"	ELSE --BNE
					'1' WHEN Opcode = "001000"	ELSE --ADDI
					'0';
	
	RegDst   <= R_format;
	RegWrite <= '1' WHEN R_format = '1' ELSE
					'1' WHEN Opcode = "001000"	ELSE -- ADDI
					'1' WHEN Opcode = "100011" ELSE -- SW
					'1' WHEN Opcode = "000011" ELSE -- JAL
					'0';
	
	MemWrite <= '1' WHEN Opcode = "101011" ELSE '0'; --Store
	MemRead  <= '0' WHEN Opcode = "101011" ELSE '1'; 
	MemToReg <= '1' WHEN Opcode = "100011" ELSE '0'; --Load
	AluSrc   <= I_Format;
	
	--Convenção:
	--Branch = 10 <- BEQ
	--Branch = 01 <- BNE
	--Observe que não é mais possível ter um sinal de 1 bit para desvios
	
	Branch( 1 ) <= '1' WHEN Opcode = "000100" ELSE -- BEQ 
						'0';

	Branch( 0 ) <= '1'  WHEN Opcode = "000101" ELSE -- BNE
						'0';
				 
	Jump 	 <= '1' WHEN Opcode = "000010" ELSE -- JMP
				 '1' WHEN Opcode = "000011" ELSE -- JAL
				 '0';
				 
	Link <= '1' WHEN Opcode = "000011" ELSE '0';
	
	AluOp(1) <= R_format;
	AluOp(0) <= '1' WHEN Opcode = "000100" ELSE '0';
	
   END behavior;


