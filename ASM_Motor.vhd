--====================================================================

-- * Descripción del comportamineto de la carta ASM del controlador 3

--====================================================================

--********************** Bibliotecas a utilizar **********************
library ieee;
use ieee.std_logic_1164.all;	  
use ieee.numeric_std.all;

--====================================================================
--********************  ********* Entidad ******************************
entity Motor is
    port(
        --Entradas
        rst,clk: in std_logic;
        A,P: in std_logic;

        --Salidas
        M: out std_logic
    );
end Motor;

--====================================================================

--*************************** Arquitectura ***************************
architecture ASM of Motor is

type estados is (S0,S1);
signal edo_pte,edo_sig : estados;

begin
--************************** Elementos de memoria ***************************
    memoria: process(clk,rst)
        begin	
            if(rst = '0') then edo_pte <= S0;	
            elsif(rising_edge(clk)) then edo_pte <= edo_sig;
		end if;
	end process memoria;

--*********************************** CLC ***********************************
    clc: process(edo_pte,P,A,rst)	
	begin
		case edo_pte is	
			when S0 => 	
                M <= '0';
                if(A = '1') then 
                    edo_sig <= S1;
                else edo_sig <= S0;
                end if;

			when S1 =>
                M <= '1';
                if(P = '1') then
                    edo_sig <= S0;
                else edo_sig <= S1;
                end if;
		end case;
    end process clc;
-----------------------------------------------------------------------------
end ASM;

--====================================================================
