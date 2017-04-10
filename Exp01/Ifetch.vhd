LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;  -- Tipo de sinal STD_LOGIC e STD_LOGIC_VECTOR
USE IEEE.STD_LOGIC_ARITH.ALL;  -- Operacoes aritmeticas sobre binarios
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.ALL; -- Componente de memoria

ENTITY Ifetch IS
	PORT(	reset			: in STD_LOGIC;
			clock			: in STD_LOGIC;
			PC_out		: out STD_LOGIC_VECTOR(7 DOWNTO 0);
			Instruction : out STD_LOGIC_VECTOR(31 DOWNTO 0));
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
-- Descreva aqui os demais sinais internos
	SIGNAL PC			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Next_PC 	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL PC_inc		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Mem_Addr	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	-- Descricao da Memoria
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
		address_a	=> mem_Addr,
		q_a			=> instruction,
		clock0		=> clock);  -- sinal de clock da memoria
	
	-- Descricao do somador
	Pc_inc <= PC + 1;
	
	-- Descricao do registrador
	PROCESS (clock, reset)
		BEGIN 
		IF reset = '1' THEN
			PC <= "00000000";
		ELSIF clock'event and clock = '1' THEN
			PC <= Next_PC;
		END IF;
	END PROCESS;
	
   PC_out <= PC;
	Next_PC <= pc_inc;
	mem_Addr <= "00000000" WHEN reset = '1' ELSE Next_PC;
END behavior;
