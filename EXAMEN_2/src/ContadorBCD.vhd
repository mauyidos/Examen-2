--********************************************************************
--***************************** Código ******************************
--********************************************************************

-- Nombre del módulo: Contador BCD
-- Tema: Control de tiempo del motor
-- Subtema: Conteo regresivo

--********************************************************************
--************************ Descripción ******************************
--********************************************************************

-- Este módulo almacena el tiempo seleccionado y realiza un conteo
-- regresivo desde el valor cargado hasta cero.
--
-- La carga se realiza mediante LD.
-- El borrado se realiza mediante CLR.
-- El decremento se realiza mediante En y PULSO_1S.
--
-- La salida CERO indica cuando el contador llega a cero.

--********************************************************************
--********************** Bibliotecas a utilizar *********************
--********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--====================================================================
--***************************** Entidad ******************************
--====================================================================

entity ContadorBCD is
    port(
        RST_GEN, CLK : in std_logic;

        CLR, LD, En : in std_logic;
        PULSO_1S : in std_logic;

        D : in std_logic_vector(3 downto 0);

        Q : out std_logic_vector(3 downto 0);
        CERO : out std_logic
    );
end ContadorBCD;

--====================================================================
--*************************** Arquitectura **************************
--====================================================================

architecture comportamiento of ContadorBCD is

    --********************** Señales internas ************************

    signal cont : unsigned(3 downto 0) := "0000";

begin

    --================================================================
    --********************** Conteo regresivo ************************
    --================================================================

    process(CLK, RST_GEN)
    begin

        if(RST_GEN = '0') then

            cont <= "0000";

        elsif(rising_edge(CLK)) then

            if(CLR = '1') then

                cont <= "0000";

            elsif(LD = '1') then

                if(unsigned(D) <= "1001") then
                    cont <= unsigned(D);
                else
                    cont <= "0000";
                end if;

            elsif(En = '1' and PULSO_1S = '1') then

                if(cont > 0) then
                    cont <= cont - 1;
                end if;

            end if;

        end if;

    end process;

    --================================================================
    --********************** Asignación de salidas ******************
    --================================================================

    Q <= std_logic_vector(cont);

    process(cont)
    begin

        if(cont = "0000") then
            CERO <= '1';
        else
            CERO <= '0';
        end if;

    end process;

end comportamiento;