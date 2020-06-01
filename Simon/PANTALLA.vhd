--VGA SIGNAL TIMING (640 * 480 60Hz)
--NAME			PIXELS
--Sync Pulse	96
--Back Porch	48
--Visible Area	640
--Front porch	16

--NAME			PIXELS
--Sync Pulse	2
--Back Porch	33
--Visible Area	480
--Front porch	10

--------------------
-- LIBRERIAS
--------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--------------------
-- ENTIDAD
--------------------
ENTITY PANTALLA IS
	PORT(	VALORH: IN INTEGER RANGE 0 TO 800;
			VALORV: IN INTEGER RANGE 0 TO 525;
			PUSH_AMARILLO: IN STD_LOGIC;
			PUSH_AZUL: IN STD_LOGIC;
			PUSH_ROJO: IN STD_LOGIC;
			PUSH_VERDE: IN STD_LOGIC;
			SWITCH_ONOFF: IN STD_LOGIC;
			SWITCH_LEVEL1: IN STD_LOGIC;
			SWITCH_LEVEL2: IN STD_LOGIC;
			SWITCH_LEVEL3: IN STD_LOGIC;
			CLOCK25MHZ: IN STD_LOGIC;
			VELOCIDAD: IN STD_LOGIC;
			R: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			G: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			B: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END PANTALLA;

--------------------
-- ARQUITECTURA
--------------------
ARCHITECTURE MAIN OF PANTALLA IS
	SIGNAL HPOS: INTEGER RANGE 0 TO 800:=0;
	SIGNAL VPOS: INTEGER RANGE 0 TO 525:=0;
	SIGNAL ILUMINACION: STD_LOGIC_VECTOR(9 DOWNTO 0):="1000001000";
	SIGNAL COLOR_BLUE1: STD_LOGIC_VECTOR(9 DOWNTO 0):="0000000000";			-- AMARILLOS
	
	SIGNAL COLOR_RED2: STD_LOGIC_VECTOR(9 DOWNTO 0):="0000000000";				-- AZUL
	SIGNAL COLOR_GREEN2: STD_LOGIC_VECTOR(9 DOWNTO 0):="0000000000";
	
	SIGNAL COLOR_GREEN3: STD_LOGIC_VECTOR(9 DOWNTO 0):="0000000000";			-- ROJO
	SIGNAL COLOR_BLUE3: STD_LOGIC_VECTOR(9 DOWNTO 0):="0000000000";
	
	SIGNAL COLOR_RED4: STD_LOGIC_VECTOR(9 DOWNTO 0):="0000000000";				-- VERDE
	SIGNAL COLOR_BLUE4: STD_LOGIC_VECTOR(9 DOWNTO 0):="0000000000";

	TYPE COLORES IS ARRAY(10 DOWNTO 1) OF INTEGER RANGE 1 TO 4;					-- ARREGLO DE COLORES
	SIGNAL COLOR: COLORES;
	SIGNAL INDICE: INTEGER:=5;
	SIGNAL TEMP_INDICE: INTEGER:=0;
	SIGNAL CONTEO: INTEGER:=1;
	
	TYPE STATE_TYPE IS (S0,S1,S2);
	SIGNAL STATE: STATE_TYPE:=(S0);
	SIGNAL PUSH_STATUS: INTEGER:=0;
	
	SIGNAL NUMEROS: STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
	
BEGIN
COLOR(1)<=2;
COLOR(2)<=4;
COLOR(3)<=1;
COLOR(4)<=3;
COLOR(5)<=1;
COLOR(6)<=2;
COLOR(7)<=3;
COLOR(8)<=4;
COLOR(9)<=4;
COLOR(10)<=3;
--------------------
-- PROCESO PANTALLA
--------------------
PROCESS(VALORH,VALORV)
BEGIN
	HPOS<=VALORH;
	VPOS<=VALORV;
--------------------
-- COLORES
--------------------
	IF((HPOS>0 AND HPOS<160) OR (VPOS>0 AND VPOS<45)) THEN																					-- PINTAR NEGRO EN LOS RANGOS FUERA DE LA PANTALLA
		R<="0000000000"; G<="0000000000"; B<="0000000000";
	END IF;

	IF((HPOS>159 AND HPOS<800) OR (VPOS>44 AND HPOS<525)) THEN																				-- FONDO NEGRO
		R<="0000000000"; G<="0000000000"; B<="0000000000";
	END IF;
	
	IF ((HPOS-480)**2 + (VPOS-285)**2>6400 AND (HPOS-480)**2 + (VPOS-285)**2<50625 AND HPOS<470 AND VPOS<275) THEN			-- NUMERO_COLOR AMARILLO
		R<="1111111111"; G<="1111111111"; B<=COLOR_BLUE1;
	END IF;
	
	IF ((HPOS-480)**2 + (VPOS-285)**2>6400 AND (HPOS-480)**2 + (VPOS-285)**2<50625 AND HPOS>470 AND VPOS<275) THEN			-- NUMERO_COLOR AZUL
		R<=COLOR_RED2; G<=COLOR_GREEN2; B<="1111111111";
	END IF;
	
	IF ((HPOS-480)**2 + (VPOS-285)**2>6400 AND (HPOS-480)**2 + (VPOS-285)**2<50625 AND HPOS<470 AND VPOS>275) THEN			-- NUMERO_COLOR ROJO
		R<="1111111111";
		G<=COLOR_GREEN3;
		B<=COLOR_BLUE3;
	END IF;
	
	IF ((HPOS-480)**2 + (VPOS-285)**2>6400 AND (HPOS-480)**2 + (VPOS-285)**2<50625 AND HPOS>470 AND VPOS>275) THEN			-- NUMERO_COLOR VERDE
		R<=COLOR_RED4; G<="1111111111"; B<=COLOR_BLUE4;
	END IF;
	
	IF((HPOS>470 AND HPOS<490) OR (VPOS>275 AND VPOS<295)) THEN																				-- LINEAS 
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	
	IF((HPOS-480)**2 + (VPOS-285)**2<3600) THEN																									-- CIRCULO BLANCO CENTRAL
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF((HPOS-480)**2 + (VPOS-285)**2>=3600 AND (HPOS-480)**2 + (VPOS-285)**2<=6400) THEN											-- CIRCULO NEGRO CENTRAL
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
-------------------
-- SWITCH ON-OFF
--------------------
	IF(SWITCH_ONOFF = '1') THEN
		IF((HPOS-460)**2 + (VPOS-310)**2<330) THEN	-- BOTON ENCENDIDO
			R<="0000000000"; G<="0000000000"; B<="0000000000";
		END IF;
		IF((HPOS-460)**2 + (VPOS-310)**2<250) THEN	
			R<="0000000000"; G<="0000000000"; B<="1111111111";
		END IF;
		IF((HPOS-460)**2 + (VPOS-313)**2<90) THEN	
			R<="1111111111"; G<="1111111111"; B<="1111111111";
		END IF;
		IF((HPOS-460)**2 + (VPOS-313)**2<30) THEN	
			R<="0000000000"; G<="0000000000"; B<="1111111111";
		END IF;
		IF(HPOS > 458 AND HPOS < 462 AND VPOS >298 AND VPOS<312) THEN
			R<="1111111111"; G<="1111111111"; B<="1111111111";
		END IF;
	END IF;
	
	IF(SWITCH_ONOFF = '0') THEN
		IF((HPOS-460)**2 + (VPOS-310)**2<330) THEN	-- BOTON APAGADO
			R<="0000000000"; G<="0000000000"; B<="0000000000";
		END IF;
		IF((HPOS-460)**2 + (VPOS-310)**2<250) THEN	
			R<="1111111111"; G<="0000000000"; B<="0000000000";
		END IF;
		IF((HPOS-460)**2 + (VPOS-313)**2<90) THEN	
			R<="1111111111"; G<="1111111111"; B<="1111111111";
		END IF;
		IF((HPOS-460)**2 + (VPOS-313)**2<30) THEN	
			R<="1111111111"; G<="0000000000"; B<="0000000000";
		END IF;
		IF(HPOS > 458 AND HPOS < 462 AND VPOS >298 AND VPOS<312) THEN
			R<="1111111111"; G<="1111111111"; B<="1111111111";
		END IF;
	END IF;
	
	IF(HPOS > 484 AND HPOS < 522 AND VPOS >298 AND VPOS<325) THEN
		R<="0000000000"; G<="0000000000"; B<="0000000000";
	END IF;
	IF(HPOS > 486 AND HPOS < 496 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 1
		R<="0000110000"; G<="0100111100"; B<="0000010000";
	END IF;
	IF(HPOS > 498 AND HPOS < 508 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 2
		R<="1101100110"; G<="1000000001"; B<="0000011000";
	END IF;
	IF(HPOS > 510 AND HPOS < 520 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 3
		R<="0111000101"; G<="0000000000"; B<="0000001100";
	END IF;
		
	IF(SWITCH_ONOFF = '1' AND SWITCH_LEVEL1 = '1' AND SWITCH_LEVEL2 = '0' AND SWITCH_LEVEL3 = '0') THEN
		IF(HPOS > 484 AND HPOS < 522 AND VPOS >298 AND VPOS<325) THEN
			R<="0000000000"; G<="0000000000"; B<="0000000000";
		END IF;
		IF(HPOS > 486 AND HPOS < 496 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 1
			R<="1011111010"; G<="1111110010"; B<="1000000101";
		END IF;
		IF(HPOS > 498 AND HPOS < 508 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 2
			R<="1100010110"; G<="1000101001"; B<="0000000100";
		END IF;
		IF(HPOS > 510 AND HPOS < 520 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 3
			R<="0111000101"; G<="0000000000"; B<="0000001100";
		END IF;
	END IF;
		
		IF(SWITCH_ONOFF = '1' AND SWITCH_LEVEL2 = '1' AND SWITCH_LEVEL1 = '0' AND SWITCH_LEVEL3 = '0') THEN
			IF(HPOS > 484 AND HPOS < 522 AND VPOS >298 AND VPOS<325) THEN
				R<="0000000000"; G<="0000000000"; B<="0000000000";
			END IF;
			IF(HPOS > 486 AND HPOS < 496 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 1
				R<="0000110000"; G<="0100111100"; B<="0000010000";
			END IF;
			IF(HPOS > 498 AND HPOS < 508 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 2
				R<="1110111010"; G<="1111100111"; B<="0110100001";
			END IF;
			IF(HPOS > 510 AND HPOS < 520 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 3
				R<="0111000101"; G<="0000000000"; B<="0000001100";
			END IF;
		END IF;
		
		IF(SWITCH_ONOFF = '1' AND SWITCH_LEVEL3 = '1' AND SWITCH_LEVEL1 = '0' AND SWITCH_LEVEL2 = '0') THEN
			IF(HPOS > 484 AND HPOS < 522 AND VPOS >298 AND VPOS<325) THEN
				R<="0000000000"; G<="0000000000"; B<="0000000000";
			END IF;
			IF(HPOS > 486 AND HPOS < 496 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 1
				R<="0000110000"; G<="0100111100"; B<="0000010000";
			END IF;
			IF(HPOS > 498 AND HPOS < 508 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 2
				R<="1100010110"; G<="1000101001"; B<="0000000100";
			END IF;
			IF(HPOS > 510 AND HPOS < 520 AND VPOS >300 AND VPOS<323) THEN -- NIVEL 3
				R<="1111111111"; G<="0001101000"; B<="0001111100";
			END IF;
		END IF;
--------------------
-- LETRAS
--------------------
-------------------------- LETRA S ------------------------------------
	IF(HPOS >435 AND HPOS<450 AND VPOS > 245 AND VPOS <250) THEN  --LETRA S
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS >435 AND HPOS<440 AND VPOS > 249 AND VPOS <260) THEN  --LETRA S
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS >435 AND HPOS<450 AND VPOS > 259 AND VPOS <265) THEN  --LETRA S
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS >445 AND HPOS<450 AND VPOS > 264 AND VPOS <275) THEN  --LETRA S
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS >435 AND HPOS<450 AND VPOS > 274 AND VPOS <280) THEN  --LETRA S
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	--------------------------------LETRA I-----------------------------------
	IF(HPOS > 452 AND HPOS<457 AND VPOS > 245 AND VPOS <280) THEN  --LETRA I
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	--------------------------------LETRA M-----------------------------------
	
	IF(HPOS > 460 AND HPOS<485 AND VPOS > 245 AND VPOS <250) THEN  --LETRA M
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 460 AND HPOS<465 AND VPOS > 249 AND VPOS <280) THEN  --LETRA M
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 470 AND HPOS<475 AND VPOS > 249 AND VPOS <270) THEN  --LETRA M
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 480 AND HPOS<485 AND VPOS > 249 AND VPOS <280) THEN  --LETRA M
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
		
	----------------------------------LETRA O---------------------------------
	IF(HPOS > 488 AND HPOS<505 AND VPOS > 245 AND VPOS <250) THEN  --LETRA O
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 488 AND HPOS<493 AND VPOS > 249 AND VPOS <276) THEN  --LETRA O
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 500 AND HPOS<505 AND VPOS > 249 AND VPOS <276) THEN  --LETRA O
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 488 AND HPOS<505 AND VPOS > 275 AND VPOS <280) THEN  --LETRA O
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	-----------------------------------LETRA N--------------------------------
	IF(HPOS > 507 AND HPOS<512 AND VPOS >245 AND VPOS <280) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 511 AND HPOS<515 AND VPOS >245 AND VPOS <250) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 513 AND HPOS<516 AND VPOS >249 AND VPOS <255) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 514 AND HPOS<517 AND VPOS >254 AND VPOS <260) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 514 AND HPOS<517 AND VPOS >259 AND VPOS <265) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 515 AND HPOS<518 AND VPOS >264 AND VPOS <270) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 515 AND HPOS<518 AND VPOS >269 AND VPOS <275) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 516 AND HPOS<520 AND VPOS >274 AND VPOS <280) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
	IF(HPOS > 519 AND HPOS<524 AND VPOS >245 AND VPOS <280) THEN  --LETRA N
		R<="0000000000";
		G<="0000000000";
		B<="0000000000";
	END IF;
--------------------
-- SCORE
--------------------
	IF(HPOS >185 AND HPOS<200 AND VPOS > 50 AND VPOS <55) THEN  --LETRA S
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >185 AND HPOS<190 AND VPOS > 54 AND VPOS <65) THEN  --LETRA S
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >185 AND HPOS<200 AND VPOS > 64 AND VPOS <70) THEN  --LETRA S
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >195 AND HPOS<200 AND VPOS > 69 AND VPOS <80) THEN  --LETRA S
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >185 AND HPOS<200 AND VPOS > 79 AND VPOS <85) THEN  --LETRA S
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >205 AND HPOS<220 AND VPOS > 50 AND VPOS <55) THEN  --LETRA C
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >205 AND HPOS<210 AND VPOS > 54 AND VPOS <80) THEN  --LETRA C
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >205 AND HPOS<220 AND VPOS > 79 AND VPOS <85) THEN  --LETRA C
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >225 AND HPOS<240 AND VPOS > 50 AND VPOS <55) THEN  --LETRA O
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >225 AND HPOS<230 AND VPOS > 54 AND VPOS <80) THEN  --LETRA O
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >235 AND HPOS<240 AND VPOS > 54 AND VPOS <80) THEN  --LETRA 0
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >225 AND HPOS<240 AND VPOS > 79 AND VPOS <85) THEN  --LETRA 0
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >245 AND HPOS<260 AND VPOS > 50 AND VPOS <55) THEN  --LETRA R
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >245 AND HPOS<250 AND VPOS > 54 AND VPOS <85) THEN  --LETRA R
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >255 AND HPOS<260 AND VPOS > 54 AND VPOS <65) THEN  --LETRA R
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >265 AND HPOS<270 AND VPOS > 50 AND VPOS <85) THEN  --LETRA E
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >269 AND HPOS<280 AND VPOS > 50 AND VPOS <57) THEN  --LETRA E
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >269 AND HPOS<275 AND VPOS > 64 AND VPOS <71) THEN  --LETRA E
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >269 AND HPOS<280 AND VPOS > 78 AND VPOS <85) THEN  --LETRA E
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >285 AND HPOS<290 AND VPOS > 60 AND VPOS <65) THEN  --DOS PUNTOS
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS >285 AND HPOS<290 AND VPOS > 70 AND VPOS <75) THEN  --DOS PUNTOS
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
--------------------
-- NUMEROS
--------------------
	IF(numeros="0000") THEN --NUMERO 00
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>236 AND HPOS<240 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
IF(HPOS>236 AND HPOS<240 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	
	END IF;
	
IF(NUMEROS="0001") THEN --NUMERO 01

IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";

	END IF;IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
END IF;

IF(numeros="0010") THEN --NUMERO 02

IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

IF(HPOS>236 AND HPOS<252 AND VPOS>110 AND VPOS<115) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

IF(HPOS>236 AND HPOS<240 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
IF(HPOS>236 AND HPOS<252 AND VPOS>125 AND VPOS<130) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
END IF;

IF(numeros="0011") THEN --NUMERO 03
IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

IF(HPOS>236 AND HPOS<252 AND VPOS>110 AND VPOS<115) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>125 AND VPOS<130) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
END IF;

IF(numeros="0100") THEN --NUMERO 04
IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>236 AND HPOS<240 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>236 AND HPOS<252 AND VPOS>110 AND VPOS<115) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
END IF;

IF(numeros="0101") THEN --NUMERO 05
IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
		
		IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>236 AND HPOS<240 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>236 AND HPOS<252 AND VPOS>110 AND VPOS<115) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>125 AND VPOS<130) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

END IF;

IF(numeros="0110") THEN --NUMERO 06
IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>236 AND HPOS<240 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>236 AND HPOS<252 AND VPOS>110 AND VPOS<115) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<240 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>236 AND HPOS<252 AND VPOS>125 AND VPOS<130) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

END IF;

IF(numeros="0111") THEN --NUMERO 07
IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

END IF;

IF(numeros="1000") THEN --NUMERO 08
IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
			IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>236 AND HPOS<240 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>110 AND VPOS<115) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<240 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>125 AND VPOS<130) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

END IF;

IF(numeros="1001") THEN --NUMERO 09
IF(HPOS>200 AND HPOS<216 AND VPOS>95 AND VPOS<100) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<204 AND VPOS>99 AND VPOS<115) THEN
	
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>200 AND HPOS<204 AND VPOS>114 AND VPOS<130) THEN 
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>200 AND HPOS<216 AND VPOS>125 AND VPOS<130) THEN
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>236 AND HPOS<240 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>110 AND VPOS<115) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

END IF;

IF(numeros="1010") THEN --NUMERO 10
	IF(HPOS>212 AND HPOS<216 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>212 AND HPOS<216 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>236 AND HPOS<252 AND VPOS>95 AND VPOS<100) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	IF(HPOS>236 AND HPOS<240 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>99 AND VPOS<115) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;

	IF(HPOS>236 AND HPOS<240 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>248 AND HPOS<252 AND VPOS>114 AND VPOS<130) THEN  
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
	
	IF(HPOS>236 AND HPOS<252 AND VPOS>125 AND VPOS<130) THEN   
		R<="1111111111";
		G<="1111111111";
		B<="1111111111";
	END IF;
END IF;
END PROCESS;
--------------------
-- PROCESOS
--------------------
PROCESS(CLOCK25MHZ)
BEGIN
	IF (RISING_EDGE(VELOCIDAD)) THEN
		CASE STATE IS
			WHEN S0 =>
				IF(COLOR(INDICE)=1)THEN
					COLOR_BLUE1<=ILUMINACION;--AMARILLO ILUMINADO
				ELSIF(COLOR(INDICE)=2)THEN
					COLOR_RED2<=ILUMINACION; COLOR_GREEN2<=ILUMINACION;--AZUL ILUMINADO
				ELSIF(COLOR(INDICE)=3)THEN
					COLOR_GREEN3<=ILUMINACION; COLOR_BLUE3<=ILUMINACION;--ROJO ILUMINADO
				ELSIF(COLOR(INDICE)=4)THEN
					COLOR_RED4<=ILUMINACION; COLOR_BLUE4<=ILUMINACION;--VERDE ILUMINADO
				END IF;
				TEMP_INDICE<=TEMP_INDICE+1;
				STATE<=S1;
			WHEN S1 =>
				COLOR_BLUE1<="0000000000";--AMARILLO DESILUMINADO
				COLOR_RED2<="0000000000"; COLOR_GREEN2<="0000000000";--AZUL DESILUMINADO
				COLOR_GREEN3<="0000000000"; COLOR_BLUE3<="0000000000";--ROJO DESILUMINADO
				COLOR_RED4<="0000000000"; COLOR_BLUE4<="0000000000";--VERDE DESILUMINADO
				IF(TEMP_INDICE=1 OR TEMP_INDICE=3 OR TEMP_INDICE=6 OR TEMP_INDICE=10 OR TEMP_INDICE=15  OR TEMP_INDICE=21 OR TEMP_INDICE=28 OR TEMP_INDICE=36 OR TEMP_INDICE=45 OR TEMP_INDICE=55) THEN
					STATE<=S2;
				ELSE
					INDICE<=INDICE+1;
					STATE<=S0;
				END IF;
			WHEN S2 =>
				IF(PUSH_AMARILLO='0') THEN COLOR_BLUE1<=ILUMINACION; PUSH_STATUS<=1;--ILUMINACION AMARILLO
				ELSIF(PUSH_AZUL='0') THEN COLOR_RED2<=ILUMINACION; COLOR_GREEN2<=ILUMINACION; PUSH_STATUS<=2;--ILUMINACION AZUL
				ELSIF(PUSH_ROJO='0') THEN COLOR_GREEN3<=ILUMINACION; COLOR_BLUE3<=ILUMINACION; PUSH_STATUS<=3;--ILUMINACION ROJO
				ELSIF(PUSH_VERDE='0') THEN COLOR_RED4<=ILUMINACION; COLOR_BLUE4<=ILUMINACION; PUSH_STATUS<=4;--ILUMINACION VERDE
				ELSE PUSH_STATUS<=0;
				END IF;
				
				IF(TEMP_INDICE>55)THEN TEMP_INDICE<=56; END IF;
				IF(NUMEROS="1010")THEN NUMEROS<="0000"; END IF;
				
				IF(PUSH_STATUS=0) THEN
					STATE<=S2;
				ELSIF(PUSH_STATUS=COLOR(CONTEO)) THEN
					IF(CONTEO<INDICE)THEN
						COLOR_BLUE1<="0000000000";--AMARILLO DESILUMINADO
						COLOR_RED2<="0000000000"; COLOR_GREEN2<="0000000000";--AZUL DESILUMINADO
						COLOR_GREEN3<="0000000000"; COLOR_BLUE3<="0000000000";--ROJO DESILUMINADO
						COLOR_RED4<="0000000000"; COLOR_BLUE4<="0000000000";--VERDE DESILUMINADO
						PUSH_STATUS<=0;
						CONTEO<=CONTEO+1;
						STATE<=S2;
					ELSE
						COLOR_BLUE1<="0000000000";--AMARILLO DESILUMINADO
						COLOR_RED2<="0000000000"; COLOR_GREEN2<="0000000000";--AZUL DESILUMINADO
						COLOR_GREEN3<="0000000000"; COLOR_BLUE3<="0000000000";--ROJO DESILUMINADO
						COLOR_RED4<="0000000000"; COLOR_BLUE4<="0000000000";--VERDE DESILUMINADO
						INDICE<=1;
						NUMEROS<=NUMEROS+'1';
						PUSH_STATUS<=0;
						CONTEO<=1;
						STATE<=S0;
					END IF;
				ELSE
					COLOR_BLUE1<="0000000000";--AMARILLO DESILUMINADO
					COLOR_RED2<="0000000000"; COLOR_GREEN2<="0000000000";--AZUL DESILUMINADO
					COLOR_GREEN3<="0000000000"; COLOR_BLUE3<="0000000000";--ROJO DESILUMINADO
					COLOR_RED4<="0000000000"; COLOR_BLUE4<="0000000000";--VERDE DESILUMINADO
					TEMP_INDICE<=0;
					NUMEROS<="0000";
					CONTEO<=1;
					INDICE<=1;
					STATE<=S0;
				END IF;
		END CASE;
	END IF;
END PROCESS;

END MAIN;