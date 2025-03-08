library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eightTo1Mux_tb is
end eightTo1Mux_tb;

architecture behavior of eightTo1Mux_tb is

    component eightTo1Mux is
        Port ( I: in STD_LOGIC_VECTOR(7 downto 0);
               S: in STD_LOGIC_VECTOR(2 downto 0);
               O: out STD_LOGIC);
    end component;

    signal I_sig : std_logic_vector(7 downto 0);
    signal S_sig : std_logic_vector(2 downto 0);
    signal O_sig : std_logic;

begin

    DUT: eightTo1Mux port map (
        I => I_sig,
        S => S_sig,
        O => O_sig
    );

    stim_proc: process
        variable temp: std_logic_vector(7 downto 0);
    begin
        -- For each input bit from 0 to 7, set that bit to '1' and the rest to '0',
        -- then set S to select that bit. The output O should then be '1'.
        for i in 0 to 7 loop
            temp := (others => '0');
            temp(i) := '1';
            I_sig <= temp;
            S_sig <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
            assert (O_sig = '1')
                report "ERROR: Test case for input bit index " & integer'image(i) & " failed"
                severity error;
        end loop;
        wait;
    end process;

end behavior;
