--*********************************************************************
--***************************  Encabezado  ****************************
--*********************************************************************

-- * Número del ejemplo:2-13
-- * Nombre del ejemplo:Motor DC
-- * Autor(es)         :
-- * Asignatura        :Circuitos Digitales
-- * Tema              :Cartas ASM
-- * Subtema           :Control de dispositivos digitales
-- * Grupo             :GG
-- * Semestre          :xxxx-x
-- * Fecha de entrega  :dd/mm/aaaa

-- * Descripción:
--   Diseñar un MEF basada en cartas ASM que controle el arranque y 
--   paro del motor DC
--   El circuito se implementará en la tarjeta Tang Nano 1k y 
--   funcionará de la siguiente manera:
--      El motor tiene dos modos de operación: 
--      + Arranque
--      + Apagado 

--Divisor de frecuencia:
--fdes = 80[Hz]
--N_on = fosc/(2*fdes) = 27000000[Hz]/(2*100[Hz]) = 135000

-- * Dispositivo lógico programable
--    - Tipo de PLD                 :FPGA 
--    - Matrícula del dispositivo   :GW1NZ-LV1
--    - Tarjeta de desarrollo       :Tang Nano 1k

-- * Notas:


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
entity Motor_TOP is
    port(
        --Entradas
        rst_TOP,clk_TOP: in std_logic;
        A_TOP,P_TOP: in std_logic;

        --Salidas
        M_TOP: out std_logic
    );
end Motor_TOP;

--====================================================================

--*************************** Arquitectura ***************************
architecture Estructura of Motor_TOP is

--Señales TOP
signal pA_TOP, pP_TOP : std_logic;

--Bloque para cartas ASM de Pulsos únicos de botones A y P
component pulso_unico is
	port(	
        --Entradas
		rst_TOP,osc : in std_logic;
		pb	  : in std_logic;
		--Salidas 
		ppb	: out std_logic );

end component pulso_unico;

--Bloque para carta ASM4 (ASM del motor)
component Motor is
    port(
        --Entradas
        rst,clk: in std_logic;
        A,P: in std_logic;

        --Salidas
        M: out std_logic
    );
end component Motor;
begin

--===================== ASM 1 (pulso único de botón Arranque) =====================
    pu_A: pulso_unico port map(
		rst_TOP => rst_TOP,
        osc => clk_TOP, 
		pb  => A_TOP,
		ppb => pA_TOP
    );
-----------------------------------------------------------------------------

--=================== ASM 2 (pulso único de botón de PARO) ==================
    pu_P: pulso_unico port map(
		rst_TOP => rst_TOP,
        osc => clk_TOP, 
		pb  => P_TOP,
		ppb => pP_TOP
    );
-----------------------------------------------------------------------------

--=============================== ASM Motor =================================
    ASM_motor: Motor port map(
		rst  => rst_TOP,
        clk  => clk_TOP, 
		A    => pA_TOP,
		P    => pP_TOP,
        M    => M_TOP
    );
-----------------------------------------------------------------------------
end Estructura;

--====================================================================