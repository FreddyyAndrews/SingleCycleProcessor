library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enabler is
    Port (
        address    : in  STD_LOGIC_VECTOR(4 downto 0);
        my_address : in  STD_LOGIC_VECTOR(4 downto 0);
        enable     : out STD_LOGIC
    );
end enabler;

architecture Structural of enabler is
    signal eq0, eq1, eq2, eq3, eq4 : STD_LOGIC;
begin
    -- Compare each corresponding bit using the built-in XNOR operator
    eq0 <= address(0) xnor my_address(0);
    eq1 <= address(1) xnor my_address(1);
    eq2 <= address(2) xnor my_address(2);
    eq3 <= address(3) xnor my_address(3);
    eq4 <= address(4) xnor my_address(4);

    -- The enable signal is true only if all bits are equal
    enable <= eq0 and eq1 and eq2 and eq3 and eq4;
end Structural;
