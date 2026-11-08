--*********************************************************************
--***************************  Encabezado  ****************************
--*********************************************************************
-- * Número del ejemplo/ejercicio: 
-- * Nombre del ejemplo/ejercicio: 
-- * Autor(es)     	: Gonzalo Emir Garía Cancino
-- * Asignatura    	: Circuitos digitales
-- * Tema          	: 
-- * Subtema       	: 
-- * Grupo         	: 4
-- * Semestre      	: 2027-1
-- * Fecha de entrega	: dd/mm/2026

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
entity controladorMotorTiempo
    port(
        --Entradas
        ARRANQUE, RST_GEN, PARO_EMG, CLK: in std_logic;
        COLUMNAS, RENGLONES: in std_logic_vector(3 downto 0);

        --Salidas
        DISPLAY1, DISPLAY2: out std_logic_vector(3 downto 0);
        MOTOR: out std_logic_vector(1 downto 0);
    );
end controladorMotorTiempo;
--====================================================================

--*************************** Arquitectura ***************************
architecture estructura of controladorMotorTiempo is
begin
end architecture;
--====================================================================