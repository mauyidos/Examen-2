--***************************** Código ******************************
--********************************************************************

-- Nombre del módulo: Controlador de tiempo
-- Asignatura: Circuitos Digitales
-- Tema: Control de tiempo del motor
-- Subtema: Controlador 2 - Máquina ASM

--********************************************************************
--************************ Descripción ******************************
--********************************************************************

-- Este controlador administra el tiempo de funcionamiento del motor.
--
-- Recibe el número seleccionado mediante NUM_SEL y espera la señal
-- ARRANQUE para iniciar el conteo.
--
-- El tiempo se decrementa una unidad cada segundo.
--
-- El motor se detiene cuando:
-- 1. El conteo llega a cero.
-- 2. Se activa PARO_EMG.
-- 3. Se activa RST_GEN.
--
-- INICIO_MOTOR solicita encender el motor.
-- FIN_TIEMPO indica que terminó el conteo.
-- APAGAR_MOTOR solicita detener el motor.

--********************************************************************
--********************** Bibliotecas a utilizar *********************
--********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--====================================================================
--***************************** Entidad ******************************
--====================================================================

entity ControladorTiempo is
    port(
        --Entradas
        RST_GEN, CLK : in std_logic;

        ARRANQUE : in std_logic;
        PARO_EMG : in std_logic;

        NUM_SEL : in std_logic_vector(3 downto 0);

        --Salidas
        INICIO_MOTOR : out std_logic;
        FIN_TIEMPO : out std_logic;
        APAGAR_MOTOR : out std_logic;

        DISPLAY2 : out std_logic_vector(3 downto 0)
    );
end ControladorTiempo;

--====================================================================
--*************************** Arquitectura **************************
--====================================================================

architecture ASM of ControladorTiempo is

    --********************** Declaración de estados *****************

    subtype estados is std_logic_vector(2 downto 0);

    constant REPOSO     : estados := "000";
    constant CARGA      : estados := "001";
    constant CUENTA     : estados := "010";
    constant FIN        : estados := "011";
    constant EMERGENCIA : estados := "100";

    signal edo_pte, edo_sig : estados;

    --********************** Señales internas ************************

    signal PULSO_1S : std_logic;
    signal q_contador : std_logic_vector(3 downto 0);
    signal cero : std_logic;

    signal ld_cont : std_logic;
    signal clr_cont : std_logic;
    signal en_cont : std_logic;

    --********************** Declaración de componentes **************

    component divisorFrec
        generic(
            N_on : natural := 27000000
        );

        port(
            RST_GEN, CLK : in std_logic;
            PULSO_1S : out std_logic
        );
    end component;

    component ContadorBCD
        port(
            RST_GEN, CLK : in std_logic;

            CLR, LD, En : in std_logic;
            PULSO_1S : in std_logic;

            D : in std_logic_vector(3 downto 0);

            Q : out std_logic_vector(3 downto 0);
            CERO : out std_logic
        );
    end component;

begin

    --================================================================
    --********************** Divisor de frecuencia ******************
    --================================================================

    U1: divisorFrec
        port map(
            RST_GEN => RST_GEN,
            CLK => CLK,
            PULSO_1S => PULSO_1S
        );

    --================================================================
    --********************** Contador BCD ****************************
    --================================================================

    U2: ContadorBCD
        port map(
            RST_GEN => RST_GEN,
            CLK => CLK,

            CLR => clr_cont,
            LD => ld_cont,
            En => en_cont,

            PULSO_1S => PULSO_1S,

            D => NUM_SEL,

            Q => q_contador,
            CERO => cero
        );

    --================================================================
    --********************** Memoria de estados *********************
    --================================================================

    memoria: process(CLK, RST_GEN)
    begin

        if(RST_GEN = '0') then

            edo_pte <= REPOSO;

        elsif(rising_edge(CLK)) then

            edo_pte <= edo_sig;

        end if;

    end process memoria;

    --================================================================
    --********************** Lógica de transición *******************
    --================================================================

    clc: process(edo_pte, ARRANQUE, PARO_EMG, cero, NUM_SEL)
    begin

        case edo_pte is

            -- Estado REPOSO

            when REPOSO =>

                if(ARRANQUE = '0') then

                    if(NUM_SEL = "0000") then
                        edo_sig <= FIN;
                    else
                        edo_sig <= CARGA;
                    end if;

                else

                    edo_sig <= REPOSO;

                end if;

            -- Estado CARGA

            when CARGA =>

                if(PARO_EMG = '0') then
                    edo_sig <= EMERGENCIA;
                else
                    edo_sig <= CUENTA;
                end if;

            -- Estado CUENTA

            when CUENTA =>

                if(PARO_EMG = '0') then

                    edo_sig <= EMERGENCIA;

                elsif(cero = '1') then

                    edo_sig <= FIN;

                else

                    edo_sig <= CUENTA;

                end if;

            -- Estado FIN

            when FIN =>

                edo_sig <= REPOSO;

            -- Estado EMERGENCIA

            when EMERGENCIA =>

                edo_sig <= REPOSO;

            when others =>

                edo_sig <= REPOSO;

        end case;

    end process clc;

    --================================================================
    --********************** Acciones de los estados ****************
    --================================================================

    acciones: process(edo_pte, PARO_EMG)
    begin

        -- Valores iniciales de las señales de control

        case edo_pte is

            -- Estado REPOSO

            when REPOSO =>

                ld_cont <= '0';
                clr_cont <= '0';
                en_cont <= '0';

                INICIO_MOTOR <= '0';
                FIN_TIEMPO <= '0';
                APAGAR_MOTOR <= '1';

            -- Estado CARGA

            when CARGA =>

                ld_cont <= '1';

                if(PARO_EMG = '1') then
                    INICIO_MOTOR <= '1';
                else
                    APAGAR_MOTOR <= '1';
                end if;

            -- Estado CUENTA

            when CUENTA =>

                en_cont <= '1';

                INICIO_MOTOR <= '1';
                APAGAR_MOTOR <= '0';

            -- Estado FIN

            when FIN =>

                INICIO_MOTOR <= '0';
                FIN_TIEMPO <= '1';
                APAGAR_MOTOR <= '1';

            -- Estado EMERGENCIA

            when EMERGENCIA =>

                clr_cont <= '1';
                APAGAR_MOTOR <= '1';

            when others =>

                null;

        end case;

    end process acciones;

    --================================================================
    --********************** Asignación de salidas ******************
    --================================================================

    DISPLAY2 <= q_contador;

end ASM;