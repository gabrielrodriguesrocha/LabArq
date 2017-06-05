LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Exp05 IS
	PORT(	reset				: IN STD_LOGIC;
			clock48MHz		: IN STD_LOGIC;
			LCD_RS, LCD_E	: OUT	STD_LOGIC;
			LCD_RW, LCD_ON	: OUT STD_LOGIC;
			DATA				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			clockPB			: IN STD_LOGIC;
			InstrALU			: IN STD_LOGIC);
END Exp05;

ARCHITECTURE exec OF Exp05 IS
COMPONENT LCD_Display
	GENERIC(NumHexDig: Integer:= 11);
	PORT(	reset, clk_48Mhz	: IN	STD_LOGIC;
			HexDisplayData		: IN  STD_LOGIC_VECTOR((NumHexDig*4)-1 DOWNTO 0);
			LCD_RS, LCD_E		: OUT	STD_LOGIC;
			LCD_RW				: OUT STD_LOGIC;
			DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;

COMPONENT Ifetch
	PORT(	reset			: in STD_LOGIC;
			clock			: in STD_LOGIC;
			Branch		: in STD_LOGIC_VECTOR(1 DOWNTO 0);
			Zero			: in STD_LOGIC;
			Jump			: in STD_LOGIC;
			JumpReg		: in STD_LOGIC;
			ADDResult 	: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			ALUResult	: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			PC_out		: out STD_LOGIC_VECTOR(7 DOWNTO 0);
			Instruction	: out STD_LOGIC_VECTOR(31 DOWNTO 0);
			InstrJump	: in STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;

COMPONENT Idecode
	PORT(	read_data_1	: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_2	: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_Result 	: IN  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Data_Mem		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				RegWrite 	: IN 	STD_LOGIC;
				RegDst 		: IN 	STD_LOGIC;
				Sign_extend : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				clock,reset	: IN 	STD_LOGIC;
				MemToReg 	: IN  STD_LOGIC;
				Jump			: IN STD_LOGIC;
				Link			: IN STD_LOGIC;
				PC				: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				MemAddr		: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0));
END COMPONENT;

COMPONENT Control
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
END COMPONENT;
	
COMPONENT Execute
	PORT( Read_data1 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Read_data2 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			PC				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			AluOp			: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			Funct			: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			ALU_Result 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			Signal_Ext 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Alu_Src		: IN STD_LOGIC;
			Zero			: OUT STD_LOGIC;
			JumpReg		: OUT STD_LOGIC;
			ADDResult 	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
			
END COMPONENT;

COMPONENT Dmemory 
	PORT(	read_data 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 				: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   	MemRead, Memwrite	: IN 	STD_LOGIC;
         clock,reset			: IN 	STD_LOGIC );
END COMPONENT;			

SIGNAL DataInstr 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL DisplayData: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL PCAddr		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL RegDst		: STD_LOGIC;
SIGNAL RegWrite	: STD_LOGIC;
SIGNAL ALUResult	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL SignExtend	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL readData1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL readData2	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL HexDisplayDT	: STD_LOGIC_VECTOR(43 DOWNTO 0);
SIGNAL auxAluSrc   : STD_LOGIC;
SIGNAL auxMemWrite : STD_LOGIC; 
SIGNAL auxMemToReg : STD_LOGIC;
SIGNAL auxMemRead  : STD_LOGIC;
SIGNAL DMemoryOut  : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL auxMemAddr  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL auxBranch 	 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL auxZero		 : STD_LOGIC;
SIGNAL auxAddResult : STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL auxAluOp	 : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL auxJump		 : STD_LOGIC;
SIGNAL auxLink 	 : STD_LOGIC;
SIGNAL auxJumpReg	 : STD_LOGIC;

BEGIN
	LCD_ON <= '1';
	
	-- Inserir MUX para DisplayData
	displayData <= DataInstr WHEN InstrALU = '1' ELSE AluResult; 
						
	HexDisplayDT <= "0000" & PCAddr & DisplayData;

	lcd: LCD_Display
	PORT MAP(
		reset				=> reset,
		clk_48Mhz		=> clock48MHz,
		HexDisplayData	=> HexDisplayDT,
		LCD_RS			=> LCD_RS,
		LCD_E				=> LCD_E,
		LCD_RW			=> LCD_RW,
		DATA_BUS			=> DATA);
	
	IFT: Ifetch
	PORT MAP(
		reset			=> reset,
		clock 		=> clockPB,
		PC_out		=> PCAddr,
		Instruction	=> DataInstr,
		Branch		=> auxBranch,
		Zero			=> auxZero,
		Jump			=> auxJump,
		JumpReg		=> auxJumpReg,
		AddResult	=> auxAddResult,
		ALUResult	=> ALUResult(7 DOWNTO 0),
		InstrJump 	=> DataInstr(7 DOWNTO 0));
		
	CTR: Control
	PORT MAP(
		Opcode 	=> DataInstr(31 DOWNTO 26),
		RegDst 	=> RegDst,
		RegWrite => RegWrite,
		MemToReg => auxMemToReg,
		MemRead 	=> auxMemRead,
		MemWrite => auxMemWrite,
		AluSrc	=> auxAluSrc,
		Branch	=> auxBranch,
		AluOp 	=> auxAluOp,
		Jump		=> auxJump,
		Link		=> auxLink);

	IDEC: Idecode
	PORT MAP(	
			read_data_1	=> readData1,
			read_data_2	=> readData2,
			Instruction => DataInstr,
			ALU_Result	=> ALUResult,
			Data_Mem		=> DMemoryOut,
			RegWrite 	=> RegWrite,
			RegDst 		=> RegDst,
			Sign_extend => SignExtend,
			clock			=> clockPB,
			reset 		=> reset,
			MemToReg 	=> auxMemToReg,
			MemAddr		=> auxMemAddr,
			Jump			=> auxJump,
			Link			=> auxLink,
			PC				=> PCAddr);

	EXE: Execute
	PORT MAP( 
			Read_data1 => readData1, 
			Read_data2 => readData2,
			ALU_Result => ALUResult,
			Signal_Ext => signExtend,
			PC			  => PCAddr,
			Alu_Src	  => auxAluSrc,
			Zero		  => auxZero,
			JumpReg	  => auxJumpReg,
			AddResult  => auxAddResult,
			AluOp		  => auxAluOp,
			Funct		  => DataInstr(5 DOWNTO 0));


	DMEM: Dmemory
	PORT MAP(	
			read_data 	=> DMemoryOut,
        	address 		=> auxMemAddr,
        	write_data 	=> readData2,
	   	MemRead		=> auxMemRead,		
			Memwrite	 	=> auxMemWrite,
         clock			=> clockPB,
			reset			=> reset);
END exec;