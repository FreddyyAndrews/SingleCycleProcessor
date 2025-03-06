library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity asyncEightBitRegister is
    Port (
        D  : in  STD_LOGIC_VECTOR(7 downto 0);
        EN : in  STD_LOGIC;
        Q  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end asyncEightBitRegister;

architecture Structural of asyncEightBitRegister is

    component dLatch is
        Port (
            D  : in  STD_LOGIC;
            EN : in  STD_LOGIC;
            Q  : out STD_LOGIC
        );
    end component;

begin

    latch0: dLatch port map (D => D(0), EN => EN, Q => Q(0));
    latch1: dLatch port map (D => D(1), EN => EN, Q => Q(1));
    latch2: dLatch port map (D => D(2), EN => EN, Q => Q(2));
    latch3: dLatch port map (D => D(3), EN => EN, Q => Q(3));
    latch4: dLatch port map (D => D(4), EN => EN, Q => Q(4));
    latch5: dLatch port map (D => D(5), EN => EN, Q => Q(5));
    latch6: dLatch port map (D => D(6), EN => EN, Q => Q(6));
    latch7: dLatch port map (D => D(7), EN => EN, Q => Q(7));

end Structural;