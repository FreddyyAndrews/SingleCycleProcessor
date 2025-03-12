library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sorter32_tb is
end sorter32_tb;

architecture test of sorter32_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component sorter32 is
        port (
            A      : in  std_logic_vector(31 downto 0);
            B      : in  std_logic_vector(31 downto 0);
            enable : in  std_logic;
            C      : out std_logic_vector(31 downto 0);
            D      : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals to connect to the UUT
    signal A, B, C, D : std_logic_vector(31 downto 0);
    signal enable   : std_logic;

begin

    -- Instantiate the sorter32 component
    uut: sorter32
        port map (
            A      => A,
            B      => B,
            enable => enable,
            C      => C,
            D      => D
        );

    -- Stimulus process with 4 test cases and assertions
    stim_proc: process
    begin
        -- Test Case 1: enable = '1', A > B
        A      <= x"0000000A";  -- 10 in hex
        B      <= x"00000005";  -- 5 in hex
        enable <= '1';
        wait for 10 ns;
        assert (C = x"0000000A") and (D = x"00000005")
            report "Test Case 1 Failed: When enable = '1' and A > B, expected C = A and D = B."
            severity error;

        -- Test Case 2: enable = '1', A < B
        A      <= x"00000003";  -- 3 in hex
        B      <= x"00000007";  -- 7 in hex
        enable <= '1';
        wait for 10 ns;
        assert (C = x"00000007") and (D = x"00000003")
            report "Test Case 2 Failed: When enable = '1' and A < B, expected C = B and D = A."
            severity error;

        -- Test Case 3: enable = '0' (pass-through), with A < B
        A      <= x"00000015";  -- 21 in hex
        B      <= x"0000001A";  -- 26 in hex
        enable <= '0';
        wait for 10 ns;
        assert (C = x"00000015") and (D = x"0000001A")
            report "Test Case 3 Failed: When enable = '0', expected pass-through with C = A and D = B."
            severity error;

        -- Test Case 4: enable = '0' (pass-through), with A > B
        A      <= x"00000020";  -- 32 in hex
        B      <= x"00000010";  -- 16 in hex
        enable <= '0';
        wait for 10 ns;
        assert (C = x"00000020") and (D = x"00000010")
            report "Test Case 4 Failed: When enable = '0', expected pass-through with C = A and D = B."
            severity error;

        report "All test cases passed.";
        wait;
    end process;

end test;
