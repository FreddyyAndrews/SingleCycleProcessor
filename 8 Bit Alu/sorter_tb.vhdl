library ieee;
use ieee.std_logic_1164.all;

entity sorter_tb is
end sorter_tb;

architecture behavior of sorter_tb is

    component sorter is
        port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            enable : in  std_logic;
            C      : out std_logic_vector(7 downto 0);
            D      : out std_logic_vector(7 downto 0)
        );
    end component;

    signal A, B, C, D : std_logic_vector(7 downto 0);
    signal enable   : std_logic;

begin

    UUT: sorter
        port map (
            A      => A,
            B      => B,
            enable => enable,
            C      => C,
            D      => D
        );

    stim: process
    begin
        -----------------------------------------------------------------
        -- Test Case 1: enable = '1', A > B (A = X"80", B = X"10")
        -----------------------------------------------------------------
        enable <= '1';
        A <= X"80";
        B <= X"10";
        wait for 10 ns;
        assert C = X"80"
            report "Test Case 1 Failed: Expected C = X'80' (greater of A and B)"
            severity error;
        assert D = X"10"
            report "Test Case 1 Failed: Expected D = X'10' (lesser of A and B)"
            severity error;

        -----------------------------------------------------------------
        -- Test Case 2: enable = '1', A < B (A = X"10", B = X"80")
        -----------------------------------------------------------------
        enable <= '1';
        A <= X"10";
        B <= X"80";
        wait for 10 ns;
        assert C = X"80"
            report "Test Case 2 Failed: Expected C = X'80' (greater of A and B)"
            severity error;
        assert D = X"10"
            report "Test Case 2 Failed: Expected D = X'10' (lesser of A and B)"
            severity error;

        -----------------------------------------------------------------
        -- Test Case 3: enable = '1', A = B (A = X"55", B = X"55")
        -----------------------------------------------------------------
        enable <= '1';
        A <= X"55";
        B <= X"55";
        wait for 10 ns;
        assert C = X"55"
            report "Test Case 3 Failed: Expected C = X'55' when A = B"
            severity error;
        assert D = X"55"
            report "Test Case 3 Failed: Expected D = X'55' when A = B"
            severity error;

        -----------------------------------------------------------------
        -- Test Case 4: enable = '0', pass-through (C = A, D = B)
        -----------------------------------------------------------------
        enable <= '0';
        A <= X"12";
        B <= X"34";
        wait for 10 ns;
        assert C = X"12"
            report "Test Case 4 Failed: Expected C = X'12' (pass-through when enable is low)"
            severity error;
        assert D = X"34"
            report "Test Case 4 Failed: Expected D = X'34' (pass-through when enable is low)"
            severity error;

        wait;
    end process;

end behavior;
