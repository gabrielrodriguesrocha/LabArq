LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;  -- Tipo de sinal STD_LOGIC e STD_LOGIC_VECTOR
USE IEEE.STD_LOGIC_ARITH.ALL;  -- Operacoes aritmeticas sobre binarios
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.ALL;

ENTITY Ifetch IS
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
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
SIGNAL PC			: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Next_PC		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL PC_inc	: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Mem_Addr	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	--Descricao da Memoria
	data_memory: altsyncram -- Declaracao do compomente de memoria
	GENERIC MAP(
		operation_mode	=> "ROM",
		width_a			=> 32, -- tamanho da palavra (Word)
		widthad_a		=> 8,   -- tamanho do barramento de endereco
		lpm_type			=> "altsyncram",
		outdata_reg_a	=> "UNREGISTERED",
		init_file		=> "program.mif",  -- arquivo com estado inicial
		intended_device_family => "Cyclone")
	PORT MAP(
		address_a	=> Mem_Addr,
		q_a			=> Instruction,
		clock0		=> clock);  -- sinal de clock da memoria
	
	-- Descricao do somador
	PC_inc <= PC+1;
	
	-- Descricao do registrador
	PROCESS
		BEGIN
		WAIT UNTIL (clock'event AND clock='1');
		IF reset='1' THEN
			PC <= "00000000";
		ELSE
			PC <= Next_PC;
		END IF;
	END PROCESS;

   -- Usar o Next_PC ao inves do PC porque a memoria tem um registrador de entrada interno
	-- Entao o PC tem que ser atualizado simultaneamente com o reg interno da memoria
	Mem_Addr <= Next_PC;
	Next_PC <= 	"00000000" WHEN reset='1' ELSE -- RESET
					ADDResult WHEN (Branch( 1 ) = '1' AND Branch( 0 ) = '0' AND Zero = '1') ELSE -- BEQ
					ADDResult WHEN (Branch( 1 ) = '0' AND Branch( 0 ) = '1' AND Zero = '0') ELSE -- BNE
					ALUResult WHEN (JumpReg = '1' AND Jump = '0') ELSE -- JR
					instrJump WHEN (Jump = '1') ELSE -- J/JAL
					PC_inc;
	PC_out <= PC;

END behavior;
