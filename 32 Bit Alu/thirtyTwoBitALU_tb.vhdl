library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity thirtyTwoBitALU_tb is
end thirtyTwoBitALU_tb;

architecture behavior of thirtyTwoBitALU_tb is

    -- Component under test
    component thirtyTwoBitALU is
        port(
            A           : in  std_logic_vector(31 downto 0);
            B           : in  std_logic_vector(31 downto 0);
            ALU_control : in  std_logic_vector(2 downto 0);
            zero        : out std_logic;
            result      : out std_logic_vector(31 downto 0)
        );
    end component;

    signal A, B         : std_logic_vector(31 downto 0);
    signal ALU_control  : std_logic_vector(2 downto 0);
    signal zero         : std_logic;
    signal result       : std_logic_vector(31 downto 0);

begin

    -- Instantiate the ALU
    DUT: thirtyTwoBitALU
        port map (
            A           => A,
            B           => B,
            ALU_control => ALU_control,
            zero        => zero,
            result      => result
        );

    stim: process
    begin
        -----------------------------------------------------------------
        -- ADD Operation (ALU_control = "000")
        -----------------------------------------------------------------
        -- Test Case 1: 5 + 10 = 15, nonzero
        A <= std_logic_vector(to_unsigned(5, 32));
        B <= std_logic_vector(to_unsigned(10, 32));
        ALU_control <= "000";  -- ADD
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(15, 32))
            report "ADD Case 1 Failed: Expected 15" severity error;
        assert zero = '0'
            report "ADD Case 1 Failed: Expected zero flag '0'" severity error;

        -- Test Case 2: 0 + 0 = 0, zero flag should be '1'
        A <= std_logic_vector(to_unsigned(0, 32));
        B <= std_logic_vector(to_unsigned(0, 32));
        ALU_control <= "000";  -- ADD
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 32))
            report "ADD Case 2 Failed: Expected 0" severity error;
        assert zero = '1'
            report "ADD Case 2 Failed: Expected zero flag '1'" severity error;

        -----------------------------------------------------------------
        -- SUB Operation (ALU_control = "001")
        -----------------------------------------------------------------
        -- Test Case 1: 10 - 5 = 5, nonzero
        A <= std_logic_vector(to_unsigned(10, 32));
        B <= std_logic_vector(to_unsigned(5, 32));
        ALU_control <= "001";  -- SUB
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(5, 32))
            report "SUB Case 1 Failed: Expected 5" severity error;
        assert zero = '0'
            report "SUB Case 1 Failed: Expected zero flag '0'" severity error;

        -- Test Case 2: 5 - 5 = 0, zero flag should be '1'
        A <= std_logic_vector(to_unsigned(5, 32));
        B <= std_logic_vector(to_unsigned(5, 32));
        ALU_control <= "001";  -- SUB
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 32))
            report "SUB Case 2 Failed: Expected 0" severity error;
        assert zero = '1'
            report "SUB Case 2 Failed: Expected zero flag '1'" severity error;

        -- Test Case 3: 55 - AA (absolute value subtraction)
        -- 0x55 - 0xAA = -0x55, whose absolute value is 0x55.
        A <= X"00000055";
        B <= X"000000AA";
        ALU_control <= "001";  -- SUB (absolute value expected)
        wait for 10 ns;
        assert result = X"00000055"
            report "SUB Case 3 Failed: Expected 0x00000055 (absolute difference of 55 - AA)" severity error;
        assert zero = '0'
            report "SUB Case 3 Failed: Expected zero flag '0'" severity error;

        -----------------------------------------------------------------
        -- AND Operation (ALU_control = "010")
        -----------------------------------------------------------------
        -- Test Case 1: X"FFFFFFFF" AND X"00000000" = X"00000000" (zero)
        A <= X"FFFFFFFF";
        B <= X"00000000";
        ALU_control <= "010";  -- AND
        wait for 10 ns;
        assert result = X"00000000"
            report "AND Case 1 Failed: Expected 0x00000000" severity error;
        assert zero = '1'
            report "AND Case 1 Failed: Expected zero flag '1'" severity error;

        -- Test Case 2: X"F0F0F0F0" AND X"FF00FF00" = X"F000F000"
        A <= X"F0F0F0F0";
        B <= X"FF00FF00";
        ALU_control <= "010";  -- AND
        wait for 10 ns;
        assert result = X"F000F000"
            report "AND Case 2 Failed: Expected 0xF000F000" severity error;
        assert zero = '0'
            report "AND Case 2 Failed: Expected zero flag '0'" severity error;

        -----------------------------------------------------------------
        -- OR Operation (ALU_control = "011")
        -----------------------------------------------------------------
        -- Test Case 1: 0 OR 0 = 0, zero flag should be '1'
        A <= std_logic_vector(to_unsigned(0, 32));
        B <= std_logic_vector(to_unsigned(0, 32));
        ALU_control <= "011";  -- OR
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 32))
            report "OR Case 1 Failed: Expected 0" severity error;
        assert zero = '1'
            report "OR Case 1 Failed: Expected zero flag '1'" severity error;

        -- Test Case 2: X"F0F0F0F0" OR X"0F0F0F0F" = X"FFFFFFFF"
        A <= X"F0F0F0F0";
        B <= X"0F0F0F0F";
        ALU_control <= "011";  -- OR
        wait for 10 ns;
        assert result = X"FFFFFFFF"
            report "OR Case 2 Failed: Expected 0xFFFFFFFF" severity error;
        assert zero = '0'
            report "OR Case 2 Failed: Expected zero flag '0'" severity error;

        -----------------------------------------------------------------
        -- Set Less Than (SLT) Operation (ALU_control = "100")
        -----------------------------------------------------------------
        -- Test Case 1: 5 < 10 so result should be 000...0001 (nonzero)
        A <= std_logic_vector(to_unsigned(5, 32));
        B <= std_logic_vector(to_unsigned(10, 32));
        ALU_control <= "100";  -- SLT
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(1, 32))
            report "SLT Case 1 Failed: Expected result with LSB = 1" severity error;
        assert zero = '0'
            report "SLT Case 1 Failed: Expected zero flag '0'" severity error;

        -- Test Case 2: 10 < 5 is false so result should be 000...0000 (zero)
        A <= std_logic_vector(to_unsigned(10, 32));
        B <= std_logic_vector(to_unsigned(5, 32));
        ALU_control <= "100";  -- SLT
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 32))
            report "SLT Case 2 Failed: Expected 0" severity error;
        assert zero = '1'
            report "SLT Case 2 Failed: Expected zero flag '1'" severity error;

        wait;
    end process;

end behavior;
