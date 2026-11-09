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
        MOTOR: out std_logic
    );
end controladorMotorTiempo;
--====================================================================

--*************************** Arquitectura ***************************
architecture estructura of controladorMotorTiempo is

--**********Inicio de las señales**********
signal clkGen: std_logic;
--Teclado
signal BI: std_logic;
signal numSel: std_logic_vector(3 downto 0);
signal dirCol: std_logic_vector(1 downto 0);
--Tiempo
signal inicioMotor, apagarMotor: std_logic;
signal finTiempo: std_logic;
--Motor
signal arranqueS, paroS: std_logic;
--==========Fin de las señales==========

--**********Inicio de los componentes**********
component divFrec is 
    generic(		
        N_on: natural := 27000000/(2 * 2) 
    );
    port(   --Entradas
            rst,clk_in : in std_logic;

            --Salidas
            clk_out : out std_logic := '0' );
end component divFrec;

component TOP_teclado_4x3 is
    port(
        --Entradas
		rst_TOP,clk_TOP : in std_logic;
        clr_TOP         : in std_logic;
		R_TOP	        : in std_logic_vector(4 downto 1); --[R4,R3,R2,R1]

		--Salidas 
		I_TOP : out std_logic_vector(1 downto 0); --[Deco de columnas]
        BCD_TOP : out std_logic_vector(3 downto 0); --[DEC 7s]
        BI_TOP  : out std_logic  --[BI del DEC 7s]
    );
end component TOP_teclado_4x3;

component Dec2x4 is
    port(
        --Entradas
        I: in std_logic_vector(1 downto 0);
        EN: in std_logic;
  
        --Salidas
        m: out std_logic_vector(3 downto 0)
    );
end component Dec2x4;

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

component Motor_TOP is
    port(
        --Entradas
        rst_TOP,clk_TOP: in std_logic;
        A_TOP,P_TOP: in std_logic;

        --Salidas
        M_TOP: out std_logic
    );
end component Motor_TOP;
--==========Fin de los componentes==========

--**********Inicio de la estructura**********
begin
    --Reloj general del circuito
    Divisor: divFrec
        generic map(N_on => 27000000/(2*120))
        port map(
            rst   => RST_GEN,
            clk_in  => CLK,
            clk_out => clkGen
        );

    --Teclado
    teclado: TOP_teclado_4x3
    port map(
        --Entradas
		rst_TOP => RST_GEN,
        clk_TOP	=> clkGen,
        clr_TOP => '1',
		R_TOP => RENGLONES,

		--Salidas 
		I_TOP => dirCol,
        BCD_TOP => numSel,
        BI_TOP => BI
    );

    decRenglones: Dec2x4
    port map(
        --Entradas
        I => dirCol,
        EN => '0',
  
        --Salidas
        m => COLUMNAS
    );

    DISPLAY1 <= numSel;

    --Control del tiempo
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

    --Control del motor
    arranqueS <= ARRANQUE or (not inicioMotor);
    paroS <= PARO_EMG or (not finTiempo) or (not apagarMotor);

    controlMotor: Motor_TOP
        port map(
            --Entradas
            rst_TOP => RST_GEN,
            clk_TOP => clkGen,
            A_TOP => arranqueS,
            P_TOP => paroS,

            --Salidas
            M_TOP => MOTOR
        );
end architecture;
--==========Fin de la estructura==========
--====================================================================