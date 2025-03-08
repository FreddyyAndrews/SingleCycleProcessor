library ieee;
use ieee.std_logic_1164.all;

entity eightX8To8Mux is
    Port ( I0: in STD_LOGIC_VECTOR(7 downto 0);
           I1: in STD_LOGIC_VECTOR(7 downto 0);
           I2: in STD_LOGIC_VECTOR(7 downto 0);
           I3: in STD_LOGIC_VECTOR(7 downto 0);
           I4: in STD_LOGIC_VECTOR(7 downto 0);
           I5: in STD_LOGIC_VECTOR(7 downto 0);
           I6: in STD_LOGIC_VECTOR(7 downto 0);
           I7: in STD_LOGIC_VECTOR(7 downto 0);
           S : in STD_LOGIC_VECTOR(2 downto 0);
           O : out STD_LOGIC_VECTOR(7 downto 0));
end eightX8To8Mux;

architecture Structural of eightX8To8Mux is

    component eightTo1Mux is
        Port ( I: in STD_LOGIC_VECTOR(7 downto 0);
               S: in STD_LOGIC_VECTOR(2 downto 0);
               O: out STD_LOGIC);
    end component;

begin

    -- Use a generate loop with a nested block that declares an internal signal.
    gen_mux: for i in 0 to 7 generate
        block_mux: block
            -- Intermediate signal to collect the i-th bit of each input vector.
            signal mux_in: std_logic_vector(7 downto 0);
        begin
            -- Assign each bit of the mux_in vector.
            mux_in(0) <= I0(i);
            mux_in(1) <= I1(i);
            mux_in(2) <= I2(i);
            mux_in(3) <= I3(i);
            mux_in(4) <= I4(i);
            mux_in(5) <= I5(i);
            mux_in(6) <= I6(i);
            mux_in(7) <= I7(i);

            mux_inst: eightTo1Mux port map (
                I => mux_in,
                S => S,
                O => O(i)
            );
        end block block_mux;
    end generate gen_mux;

end Structural;
