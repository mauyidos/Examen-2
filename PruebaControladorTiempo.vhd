--********************************************************************
--*****************************  Código  *****************************
--********************************************************************

--********************** Bibliotecas a utilizar **********************
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--====================================================================

--***************************** Entidad ******************************
entity Prueba is
port(
        --Entradas
        rstTop, osc, inicio: in std_logic;
        --Salidas
        RGB: out std_logic_vector(2 downto 0)
);
end Prueba;
--====================================================================

--*************************** Arquitectura ***************************
architecture estructura of Prueba is
signal NCvec, display: std_logic_vector(3 downto 0);

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

begin
    controlT: ControladorTiempo
        port map(
            --Entradas
            RST_GEN => '1',
            CLK => osc,

            ARRANQUE => inicio,
            PARO_EMG => rstTop,

            NUM_SEL => "0111",

            --Salidas
            INICIO_MOTOR => NCvec(0),
            FIN_TIEMPO => NCvec(1),
            APAGAR_MOTOR => NCvec(2),

            DISPLAY2 => display
        );

    RGB(0) <= not display(0);
    RGB(1) <= not display(1);
    RGB(2) <= not display(2);
end estructura;
--====================================================================