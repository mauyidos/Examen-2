-- * Descripción:
--   Se tiene el cristal de cuarzo de la tarjeta Tang Nano 1k que 
--   proporciona una señal de reloj de 27 [MHz] y se desea obtener una
--   señal de menor frecuencia a partir de la señal original. 
--   La frecuencia que se desea obtener es de exactamente 2 [Hz].
--   Diseñe un divisor de frecuencia basado en un contador binario para
--   proporcionar dicha señal de reloj.
--      N_on = fosc/(2*fdes) = 27000000[Hz]/(2 * 2[Hz])
--      bits = log_2(6750000) = 22.69 -> 23 bits

-- * Dispositivo lógico programable
--    - Tipo de PLD                 :FPGA 
--    - Matrícula del dispositivo   :GW1NZ-LV1
--    - Tarjeta de desarrollo       :Tang Nano 1k

-- * Notas:
--    - Salidas : clk_out -> Señal de reloj de 2 Hz.
--    - Entradas: clk_in -> Reloj de 27 MHz de la Tang Nano 1K.
--                rst -> Reinicio activo en bajo.
--    - No requiere conexiones externas adicionales.

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
entity divFrec is 
    generic(		
        N_on: natural := 27000000/(2 * 2) 
    );
    port(   --Entradas
            rst,clk_in : in std_logic;

            --Salidas
            clk_out : out std_logic := '0' );
end divFrec;

--====================================================================

--*************************** Arquitectura ***************************
architecture comportamiento of divFrec is

signal s_clk_out: std_logic := '0';
signal cont: integer range 0 to N_on-1 := 0;

begin 
    process(rst,clk_in) is
    begin 
        if(rst = '0') then
            s_clk_out <= '0';
            cont <= 0; 
        elsif(rising_edge(clk_in)) then
            if(cont = N_on-1) then
                s_clk_out <= not s_clk_out;
                cont <= 0;
            else
                cont <= cont + 1;
            end if;
        end if;
    end process;
    clk_out <= s_clk_out;
end comportamiento;

--====================================================================
