LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MULTIPLEXORSIMON IS 
	PORT(	CLK1: IN STD_LOGIC;
			CLK2: IN STD_LOGIC;
			CLK3: IN STD_LOGIC;
			PUSH1: IN STD_LOGIC;
			PUSH2: IN STD_LOGIC;
			PUSH3: IN STD_LOGIC;
			PUSH_ONOFF: IN STD_LOGIC;
			SALIDA: OUT STD_LOGIC);
	END MULTIPLEXORSIMON;
	
ARCHITECTURE RTL OF MULTIPLEXORSIMON IS 
BEGIN
	PROCESS(CLK3)
		VARIABLE TEMP: STD_LOGIC;
	BEGIN
		IF(PUSH1 = '1' AND PUSH2 = '0' AND PUSH3 = '0' AND PUSH_ONOFF = '1') THEN
			TEMP:=CLK1;
		END IF;
		
		IF(PUSH2 = '1' AND PUSH1 = '0' AND PUSH3 = '0' AND PUSH_ONOFF = '1') THEN
			TEMP:=CLK2;
		END IF;
		
		IF(PUSH3 = '1' AND PUSH1 = '0' AND PUSH2 = '0' AND PUSH_ONOFF = '1') THEN
			TEMP:=CLK3;
		END IF;
		
		SALIDA<=TEMP;
	END PROCESS;
END RTL;