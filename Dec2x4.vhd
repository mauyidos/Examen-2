--Descripción en VHDL de un decodificador de 2 x 4 con señal de
--enable. La señal de enable pone en 0 todas las salidas.

--********************************************************************
--*****************************  Código  *****************************
--********************************************************************

--********************** Bibliotecas a utilizar **********************
library ieee;
use ieee.std_logic_1164.all;	  
use ieee.numeric_std.all;

--====================================================================

--***************************** Entidad ******************************
entity Dec2x4 is
    port(
        --Entradas
        I: in std_logic_vector(1 downto 0);
        EN: in std_logic;
  
        --Salidas
        m: out std_logic_vector(3 downto 0)
    );
end Dec2x4;

--====================================================================

--*************************** Arquitectura ***************************
architecture TV of Dec2x4 is
signal D: std_logic_vector(3 downto 0);
begin
    D <=   "0001" when I = "00" else
           "0010" when I = "01" else
           "0100" when I = "10" else
           "1000";
    m <= not D when EN = '0' else "1111";       
end TV;

--====================================================================