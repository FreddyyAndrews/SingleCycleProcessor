LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY twoBy8To8Mux IS
    PORT(
        A      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        B      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        sel    : IN  STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END twoBy8To8Mux;

ARCHITECTURE Structural OF twoBy8To8Mux IS

    -- 2-to-1 mux entity definition
    component mux2 IS
        PORT(
            sel : IN  STD_LOGIC; -- Select signal
            a   : IN  STD_LOGIC; -- Data input 0
            b   : IN  STD_LOGIC; -- Data input 1
            y   : OUT STD_LOGIC  -- Multiplexer output
        );
    END component;

BEGIN

    -- Generate 8 instances of mux2 for each bit of the input vectors
    gen_mux: FOR i IN 7 DOWNTO 0 GENERATE
        U: mux2 PORT MAP (
            sel => sel,    -- Shared select signal
            a   => A(i),   -- Bit i of input A
            b   => B(i),   -- Bit i of input B
            y   => result(i)  -- Bit i of the result
        );
    END GENERATE gen_mux;

END Structural;
