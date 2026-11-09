--====================================================================

-- * Descripción en VHDL de un multiplexor parametrizado con FPGA.

--====================================================================

--********************** Bibliotecas a utilizar **********************
library ieee;
use ieee.std_logic_1164.all;	  
use ieee.numeric_std.all;

--====================================================================

--***************************** Entidad ******************************
entity MUX2x1 is
    port(
        --Entradas
        X0,X1: in std_logic_vector(3 downto 0);
        Z0: in std_logic; 

        --Salidas
        Y: out std_logic_vector(3 downto 0) 
    );

end MUX2x1;

--====================================================================

--*************************** Arquitectura ***************************
architecture TV of MUX2x1 is
signal E0, E1, S: std_logic_vector(3 downto 0);
signal L0: std_logic;
begin

    with L0 select
        S <=    E0 when '0',
                E1 when others;
    E1 <= X1;
    E0 <= X0;
    L0 <= Z0; 
    Y  <= S;

end TV;

--====================================================================