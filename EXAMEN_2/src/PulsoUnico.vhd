--*********************************************************************
--***************************  Encabezado  ****************************
--*********************************************************************

-- * Número del ejemplo:2-10
-- * Nombre del ejemplo:Pulso Único
-- * Autor(es)         :Ignacio Rangel Fuerte
-- * Asignatura        :Circuitos Digitales
-- * Tema              :Cartas ASM
-- * Subtema           :
-- * Grupo             :GG
-- * Semestre          :xxxx-x
-- * Fecha de entrega  :dd/mm/aaaa

-- * Descripción:
--   Utilizando cartas ASM, diseñar un circuito en el que al presionar
--   un botón pulsador, se produzca un único pulso independientemente
--   de si se presiona una vez el botón o éste se mantiene presionado.

-- * Dispositivo lógico programable
--    - Tipo de PLD                 :FPGA 
--    - Matrícula del dispositivo   :GW1NZ-LV1
--    - Tarjeta de desarrollo       :Tang Nano 1k

-- * Notas:
--    - Salidas : pPB -> 31
--    - Entradas: [RST OSC PB] -> [13 47 46]
--    - Entradas con resistor a Pull Up.

--==================================================================== 

--********************************************************************
--*****************************  Código  *****************************
--********************************************************************

--********************** Bibliotecas a utilizar **********************
library ieee;
use ieee.std_logic_1164.all;	  
use ieee.numeric_std.all;

--====================================================================

--***************************** Entidad ******************************
entity pulso_unico is
	port(	
        --Entradas
		rst_TOP,osc : in std_logic;
		pb	  : in std_logic;

		--Salidas 
		ppb	: out std_logic );
end pulso_unico;	

--====================================================================

--*************************** Arquitectura ***************************
architecture ASM of pulso_unico is

--Señales para carta ASM
type estados is (s0,s1);
signal edo_pte,edo_sig : estados;

begin
--================================== ASM ====================================
--************************** Elementos de memoria ***************************
	memoria: process(osc,rst_TOP)	
	begin				
		if(rst_TOP = '0') then edo_pte <= s0;
		elsif(rising_edge(osc)) then edo_pte <= edo_sig;
		end if;
	end process memoria;

--*********************************** CLC ***********************************
	clc: process(pb,edo_pte)
	begin		
		case edo_pte is	
			when s0 =>  
				if(pb = '0') then   
					edo_sig <= s1;  
					ppb <= '1';	    
				else		    
					edo_sig <= s0;   
					ppb <= '0'; 
				end if; 
			when s1 =>  
				if(pb = '0') then   
					edo_sig <= s1;  
					ppb <= '0'; 
				else		    
					edo_sig <= s0;  
					ppb <= '0';	    
				end if;	    
		end case;		    
	end process clc;    	
end ASM;			    

--====================================================================


