--*********************************************************************
--***************************  Encabezado  ****************************
--*********************************************************************
-- * Número del examen: 2
-- * Autores     	: Gonzalo Emir Garía Cancino
--                    Juan Pablo Velazquez Muro
--                    Alejandro de Jesus Astorga Castillo
-- * Asignatura    	: Circuitos digitales
-- * Tema          	: 2
-- * Subtema       	: Cartas ASM
-- * Grupo         	: 4
-- * Semestre      	: 2027-1
-- * Fecha de entrega	: 09/11/2026

-- * Descripción:
--    Describir el funcionamiento que debe tener el circuito interno
--    y el externo.

-- * Dispositivo lógico programable
--    - Tipo de PLD                 :FPGA 
--    - Matrícula del dispositivo   :GW1NZ-LV1
--    - Tarjeta de desarrollo       :Tang Nano 1k

-- * Notas: p.ej. 
--    - Conexión de LED a pin 31...
--    - Configuración de resistor de PULL 
--    - etc.
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
entity controladorMotorTiempo is
    port(
        --Entradas
        RST_GEN, CLK: in std_logic;
        ARRANQUE, PARO_EMG: in std_logic;
        RENGLONES: in std_logic_vector(3 downto 0);

        --Salidas
        COLUMNAS: out std_logic_vector(3 downto 0);
        DISPLAY1, DISPLAY2: out std_logic_vector(3 downto 0);
        MOTOR: out std_logic_vector(1 downto 0)
    );
end controladorMotorTiempo;
--====================================================================

--*************************** Arquitectura ***************************
architecture estructura of controladorMotorTiempo is

--**********Inicio de las señales**********
signal inicioMotor, apagarMotor: std_logic;
signal finTiempo: std_logic;
signal numSel: std_logic_vector(3 downto 0);
--==========Fin de las señales==========

--**********Inicio de los componentes**********
component ControladorTiempo is
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
end component ControladorTiempo;
--==========Fin de los componentes==========

--**********Inicio de la estructura**********
begin
    contolTiempo: ControladorTiempo
        port map(
            --Entradas
            RST_GEN => RST_GEN,
            CLK => CLK,

            ARRANQUE => ARRANQUE,
            PARO_EMG => PARO_EMG,

            NUM_SEL => numSel,

            --Salidas
            INICIO_MOTOR => inicioMotor,
            FIN_TIEMPO => finTiempo,
            APAGAR_MOTOR => apagarMotor,

            DISPLAY2 => DISPLAY2
        );
end architecture;
--==========Fin de la estructura==========
--====================================================================