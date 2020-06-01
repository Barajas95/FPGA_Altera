LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SYNC IS
	PORT(	CLK: IN STD_LOGIC;
			HSYNC: OUT STD_LOGIC;
			VSYNC: OUT STD_LOGIC;
			R: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			G: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			B: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END SYNC;

ARCHITECTURE MAIN OF SYNC IS
	SIGNAL HPOS: INTEGER RANGE 0 TO 800:=0;
	SIGNAL VPOS: INTEGER RANGE 0 TO 525:=0;
BEGIN

PROCESS(CLK)
BEGIN
	IF(CLK'EVENT AND CLK='1') THEN
	
		IF(HPOS>475 AND HPOS<485) THEN
			R<="0000000000";
			G<="1111111111";			--PINTAR LINEA VERDE
			B<="0000000000";
		ELSE
			R<="0000000000";
			G<="0000000000";
			B<="0000000000";
		END IF;
	
		IF (HPOS<800) THEN
			HPOS<=HPOS+1;
		ELSE
			HPOS<=0;
			IF (VPOS<525) THEN
				VPOS<=VPOS+1;
			ELSE
				VPOS<=0;
			END IF;
		END IF;		
	END IF;
	
	IF(HPOS>16 AND HPOS<112) THEN
		HSYNC<='0';
	ELSE
		HSYNC<='1';
	END IF;
	
	IF(VPOS>10 AND VPOS<12) THEN
		VSYNC<='0';
	ELSE
		VSYNC<='1';
	END IF;
	
	IF((HPOS>0 AND HPOS<160) OR (VPOS>0 AND VPOS<45)) THEN
		R<="0000000000";		--PINTAR NEGRO EN LOS RANGOS FUERA DE LA PANTALLA
		G<="0000000000";
		B<="0000000000";
	END IF;
	
END PROCESS;

END MAIN;