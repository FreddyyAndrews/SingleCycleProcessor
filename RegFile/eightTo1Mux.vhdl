library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity eightTo1Mux is
    Port ( I: in STD_LOGIC_VECTOR(7 downto 0);
           S : in STD_LOGIC_VECTOR(2 downto 0);
           O : out STD_LOGIC);
end eightTo1Mux;

architecture Structural of eightTo1Mux is

    Signal and_out: STD_LOGIC_VECTOR(7 downto 0);

begin

    and_out(0) <= I(0) and (not S(0)) and (not S(1)) and (not S(2));
    and_out(1) <= I(1) and S(0) and (not S(1)) and (not S(2));
    and_out(2) <= I(2) and (not S(0)) and  S(1) and (not S(2));
    and_out(3) <= I(3) and S(0) and S(1) and (not S(2));
    and_out(4) <= I(4) and (not S(0)) and (not S(1)) and S(2);
    and_out(5) <= I(5) and S(0) and (not S(1)) and  S(2);
    and_out(6) <= I(6) and (not S(0)) and S(1) and S(2);
    and_out(7) <= I(7) and S(0) and S(1) and S(2);

    O <= and_out(0) or and_out(1) or and_out(2) or and_out(3) or and_out(4) or and_out(5) or and_out(6) or and_out(7);

end Structural;