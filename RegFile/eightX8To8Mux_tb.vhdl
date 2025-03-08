library ieee;
use ieee.std_logic_1164.all;

entity eightX8To8Mux_tb is
end eightX8To8Mux_tb;

architecture behavior of eightX8To8Mux_tb is

    component eightX8To8Mux is
        Port (
            I0 : in  std_logic_vector(7 downto 0);
            I1 : in  std_logic_vector(7 downto 0);
            I2 : in  std_logic_vector(7 downto 0);
            I3 : in  std_logic_vector(7 downto 0);
            I4 : in  std_logic_vector(7 downto 0);
            I5 : in  std_logic_vector(7 downto 0);
            I6 : in  std_logic_vector(7 downto 0);
            I7 : in  std_logic_vector(7 downto 0);
            S  : in  std_logic_vector(2 downto 0);
            O  : out std_logic_vector(7 downto 0)
        );
    end component;

    signal I0_sig, I1_sig, I2_sig, I3_sig, I4_sig, I5_sig, I6_sig, I7_sig : std_logic_vector(7 downto 0);
    signal S_sig : std_logic_vector(2 downto 0) := "000";
    signal O_sig : std_logic_vector(7 downto 0);

begin

    DUT: eightX8To8Mux port map (
        I0 => I0_sig,
        I1 => I1_sig,
        I2 => I2_sig,
        I3 => I3_sig,
        I4 => I4_sig,
        I5 => I5_sig,
        I6 => I6_sig,
        I7 => I7_sig,
        S  => S_sig,
        O  => O_sig
    );

    stim_proc: process
    begin
        -- Set distinct constant values for each input
        I0_sig <= "00000001";  -- 1
        I1_sig <= "00000010";  -- 2
        I2_sig <= "00000011";  -- 3
        I3_sig <= "00000100";  -- 4
        I4_sig <= "00000101";  -- 5
        I5_sig <= "00000110";  -- 6
        I6_sig <= "00000111";  -- 7
        I7_sig <= "00001000";  -- 8
        wait for 10 ns;
        
        -- Test each select value with a simple error message
        S_sig <= "000";  -- Expect I0_sig
        wait for 10 ns;
        assert (O_sig = I0_sig)
            report "ERROR: Case for S = 000 failed" severity error;
        
        S_sig <= "001";  -- Expect I1_sig
        wait for 10 ns;
        assert (O_sig = I1_sig)
            report "ERROR: Case for S = 001 failed" severity error;
        
        S_sig <= "010";  -- Expect I2_sig
        wait for 10 ns;
        assert (O_sig = I2_sig)
            report "ERROR: Case for S = 010 failed" severity error;
        
        S_sig <= "011";  -- Expect I3_sig
        wait for 10 ns;
        assert (O_sig = I3_sig)
            report "ERROR: Case for S = 011 failed" severity error;
        
        S_sig <= "100";  -- Expect I4_sig
        wait for 10 ns;
        assert (O_sig = I4_sig)
            report "ERROR: Case for S = 100 failed" severity error;
        
        S_sig <= "101";  -- Expect I5_sig
        wait for 10 ns;
        assert (O_sig = I5_sig)
            report "ERROR: Case for S = 101 failed" severity error;
        
        S_sig <= "110";  -- Expect I6_sig
        wait for 10 ns;
        assert (O_sig = I6_sig)
            report "ERROR: Case for S = 110 failed" severity error;
        
        S_sig <= "111";  -- Expect I7_sig
        wait for 10 ns;
        assert (O_sig = I7_sig)
            report "ERROR: Case for S = 111 failed" severity error;
        
        wait;  -- End simulation
    end process;

end behavior;
