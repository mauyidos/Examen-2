--********************************************************************
--***************************** Código ******************************
--********************************************************************

-- Nombre del módulo: Divisor de frecuencia
-- Tema: Control de tiempo del motor
-- Subtema: Generación de pulso de un segundo

--********************************************************************
--************************ Descripción ******************************
--********************************************************************

-- Este módulo genera un pulso de un ciclo de reloj cada segundo.
--
-- Se utiliza el oscilador de 27 MHz de la FPGA Tang Nano 1K.
--
-- La señal PULSO_1S permite controlar el decremento del contador
-- de tiempo una vez por segundo.

--********************************************************************
--********************** Bibliotecas a utilizar *********************
--********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--====================================================================
--***************************** Entidad ******************************
--====================================================================

entity divisorFrec is
    generic(
        N_on : natural := 27000000
    );

    port(
        RST_GEN, CLK : in std_logic;
        PULSO_1S : out std_logic
    );
end divisorFrec;

--====================================================================
--*************************** Arquitectura **************************
--====================================================================

architecture comportamiento of divisorFrec is

    --********************** Señales internas ************************

    signal cont : integer range 0 to N_on-1 := 0;
    signal pulso : std_logic := '0';

begin

    --================================================================
    --********************** División de frecuencia *****************
    --================================================================

    process(CLK, RST_GEN)
    begin

        if(RST_GEN = '0') then

            cont <= 0;
            pulso <= '0';

        elsif(rising_edge(CLK)) then

            if(cont = N_on-1) then

                cont <= 0;
                pulso <= '1';

            else

                cont <= cont + 1;
                pulso <= '0';

            end if;

        end if;

    end process;

    --================================================================
    --********************** Asignación de salida *******************
    --================================================================

    PULSO_1S <= pulso;

end comportamiento;