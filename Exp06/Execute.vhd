LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
--USE IEEE.NUMERIC_STD.ALL;

ENTITY Execute IS
	PORT( Read_data1 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Read_data2 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			PC				: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			AluOp			: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			Funct			: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			ALU_Result 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			Signal_Ext 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			Shamt			: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			Alu_Src		: IN STD_LOGIC;
			Zero			: OUT STD_LOGIC;
			JumpReg		: OUT STD_LOGIC;
			ADDResult 	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END Execute;

ARCHITECTURE behavior OF Execute IS
	SIGNAL iAux 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Alu_ctl : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Shift	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	BEGIN
	
	--Lógica que gera os códigos de operação na ALU
	--	Necessário alterar para implementar SLL/SRL (i.e. fazer outra Tabela-Verdade)
	--	Favor testar todas as instruções implementadas antes e após alterar a lógica!!!
	--ALU_ctl( 0 ) <= (Funct(0) OR Funct(3)) AND ALUOp(1);
	--ALU_ctl( 1 ) <= (NOT Funct(2)) OR (NOT ALUOp(1)) OR Funct(1);
	--ALU_ctl( 2 ) <= (Funct(1) AND ALUOp(1)) OR ALUOp(0);
	--ALU_ctl( 3 ) <= (Funct(3)) AND AluOp(1); --Convenção: 1000 é Jump, ver tabela no Patterson
	
	--Lógica que gera os códigos de operação na ALU
	-- Observe que agora as codificações são um pouco diferentes
	-- O código referente ao SLL é uma "gambiarrazinha" pois seu function code é inteiramente nulo
	-- Acho que a lógica abaixo é uma das que minimizam o número de operações lógicas
	-- Observe também que como a única operação I-format implementada (addi) faz apenas soma,
	-- todas as operações requerem que AluOp(1) (sinal de R-format) esteja alto, caso contrário a soma é realizada.
	ALU_ctl(4) <= (NOT(Funct(5) OR Funct(4) OR Funct(3) OR Funct(2) OR Funct(1) OR Funct(0))) AND AluOp(1);
	ALU_ctl(3) <= AluOp(1) AND Funct(3);
	ALU_ctl(2) <= Funct(1) AND AluOp(1);
	Alu_ctl(1) <= NOT (((Funct(5) AND Funct(2)) OR (NOT (Funct(5)) AND Funct(3)) OR (NOT (Funct(5)) AND Funct(1))) AND AluOp(1));
	Alu_ctl(0) <= ((Funct(2) AND Funct(0)) OR (Funct(3) AND Funct(1))) AND AluOp(1);
	
	iAux <= Read_data2 WHEN Alu_src = '0' ELSE Signal_Ext;
	
	PROCESS ( ALU_ctl, Read_data1, Read_data2, iAux, Shamt )
		VARIABLE TMP	: STD_LOGIC_VECTOR(31 DOWNTO 0);
		BEGIN
		-- Seleciona a operação da ALU
		CASE ALU_ctl IS
			-- Operação E lógico
			WHEN "00000" => ALU_Result <= Read_data1 AND iAux;
			-- Operação OU lógico
			WHEN "00001" => ALU_Result <= Read_data1 OR iAux;
			-- Operação de Soma
			WHEN "00010" => ALU_Result <= Read_data1 + iAux;
			-- Operação de Subtração
			WHEN "00110" => ALU_Result <= Read_data1 - iAux;
			-- Operação SLT
			WHEN "00111" => ALU_Result <= Read_data1 - iAux;
			-- Operação JR (truque sujo)
			WHEN "01000" => ALU_Result <= Read_data1;
			-- Operação SRL
			WHEN "00100" => ALU_Result <= SHR((Read_data2), (Shamt));
			-- Operação SLL
			WHEN "10010" => ALU_Result <= SHL((Read_data2), (Shamt));
			WHEN OTHERS => ALU_Result <= Read_data1; --Placeholder, alterar depois
		END CASE;
	END PROCESS;
	
	Zero <= '0' WHEN (Read_data1 /= Read_data2) ELSE '1';
	
	--Convenção:
	-- JumpReg é o sinal para instrução JR
	-- No módulo Ifetch, PC receberá a saída da ALU quando JumpReg for alto
	-- E nesse caso, a saída será exatamente o registrador destino, comumente o $ra (ver PROCESS acima)
	JumpReg <= '1' WHEN ALU_ctl(3) = '1' ELSE '0';
	
	ADDResult <= PC + 1 + Signal_Ext (7 DOWNTO 0);

END behavior;
