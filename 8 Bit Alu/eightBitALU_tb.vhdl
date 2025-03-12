library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eightBitALU_tb is
end eightBitALU_tb;

architecture behavior of eightBitALU_tb is

    -- Component under test
    component eightBitALU is
        port(
            A           : in  std_logic_vector(7 downto 0);
            B           : in  std_logic_vector(7 downto 0);
            ALU_control : in  std_logic_vector(2 downto 0);
            zero        : out std_logic;
            result      : out std_logic_vector(7 downto 0)
        );
    end component;

    signal A, B         : std_logic_vector(7 downto 0);
    signal ALU_control  : std_logic_vector(2 downto 0);
    signal zero         : std_logic;
    signal result       : std_logic_vector(7 downto 0);

begin

    -- Instantiate the ALU
    DUT: eightBitALU
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
        A <= std_logic_vector(to_unsigned(5, 8));
        B <= std_logic_vector(to_unsigned(10, 8));
        ALU_control <= "000";  -- ADD
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(15, 8))
            report "ADD Case 1 Failed: Expected 15" severity error;
        assert zero = '0'
            report "ADD Case 1 Failed: Expected zero flag '0'" severity error;

        -- Test Case 2: 0 + 0 = 0, zero flag should be '1'
        A <= std_logic_vector(to_unsigned(0, 8));
        B <= std_logic_vector(to_unsigned(0, 8));
        ALU_control <= "000";  -- ADD
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 8))
            report "ADD Case 2 Failed: Expected 0" severity error;
        assert zero = '1'
            report "ADD Case 2 Failed: Expected zero flag '1'" severity error;

                -----------------------------------------------------------------
        -- SUB Operation (ALU_control = "001")
        -----------------------------------------------------------------
        -- Test Case 1: 10 - 5 = 5, nonzero
        A <= std_logic_vector(to_unsigned(10, 8));
        B <= std_logic_vector(to_unsigned(5, 8));
        ALU_control <= "001";  -- SUB
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(5, 8))
            report "SUB Case 1 Failed: Expected 5" severity error;
        assert zero = '0'
            report "SUB Case 1 Failed: Expected zero flag '0'" severity error;

        -- Test Case 2: 5 - 5 = 0, zero flag should be '1'
        A <= std_logic_vector(to_unsigned(5, 8));
        B <= std_logic_vector(to_unsigned(5, 8));
        ALU_control <= "001";  -- SUB
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 8))
            report "SUB Case 2 Failed: Expected 0" severity error;
        assert zero = '1'
            report "SUB Case 2 Failed: Expected zero flag '1'" severity error;

        -- Test Case 3: 55 - AA (hex) 
        -- 0x55 - 0xAA = -0x55, which in 8-bit two's complement is 0xAB.
        A <= X"55";
        B <= X"AA";
        ALU_control <= "001";  -- SUB
        wait for 10 ns;
        assert result = X"55"
            report "SUB Case 3 Failed: Expected 0x55" severity error;
        assert zero = '0'
            report "SUB Case 3 Failed: Expected zero flag '0'" severity error;

        -----------------------------------------------------------------
        -- AND Operation (ALU_control = "010")
        -----------------------------------------------------------------
        -- Test Case 1: X"FF" AND X"00" = X"00" (zero)
        A <= X"FF";
        B <= X"00";
        ALU_control <= "010";  -- AND
        wait for 10 ns;
        assert result = X"00"
            report "AND Case 1 Failed: Expected 0x00" severity error;
        assert zero = '1'
            report "AND Case 1 Failed: Expected zero flag '1'" severity error;

        -- Test Case 2: X"F0" AND X"F0" = X"F0"
        A <= X"F0";
        B <= X"F0";
        ALU_control <= "010";  -- AND
        wait for 10 ns;
        assert result = X"F0"
            report "AND Case 2 Failed: Expected 0xF0" severity error;
        assert zero = '0'
            report "AND Case 2 Failed: Expected zero flag '0'" severity error;

        -----------------------------------------------------------------
        -- OR Operation (ALU_control = "011")
        -----------------------------------------------------------------
        -- Test Case 1: 0 OR 0 = 0, zero flag should be '1'
        A <= std_logic_vector(to_unsigned(0, 8));
        B <= std_logic_vector(to_unsigned(0, 8));
        ALU_control <= "011";  -- OR
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 8))
            report "OR Case 1 Failed: Expected 0" severity error;
        assert zero = '1'
            report "OR Case 1 Failed: Expected zero flag '1'" severity error;

        -- Test Case 2: X"F0" OR X"0F" = X"FF"
        A <= X"F0";
        B <= X"0F";
        ALU_control <= "011";  -- OR
        wait for 10 ns;
        assert result = X"FF"
            report "OR Case 2 Failed: Expected 0xFF" severity error;
        assert zero = '0'
            report "OR Case 2 Failed: Expected zero flag '0'" severity error;

        -----------------------------------------------------------------
        -- Set Less Than (SLT) Operation (ALU_control = "100")
        -----------------------------------------------------------------
        -- Test Case 1: 5 < 10 so result should be 00000001 (nonzero)
        A <= std_logic_vector(to_unsigned(5, 8));
        B <= std_logic_vector(to_unsigned(10, 8));
        ALU_control <= "100";  -- SLT
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(1, 8))
            report "SLT Case 1 Failed: Expected result with LSB = 1" severity error;
        assert zero = '0'
            report "SLT Case 1 Failed: Expected zero flag '0'" severity error;

        -- Test Case 2: 10 < 5 is false so result should be 00000000 (zero)
        A <= std_logic_vector(to_unsigned(10, 8));
        B <= std_logic_vector(to_unsigned(5, 8));
        ALU_control <= "100";  -- SLT
        wait for 10 ns;
        assert result = std_logic_vector(to_unsigned(0, 8))
            report "SLT Case 2 Failed: Expected 0" severity error;
        assert zero = '1'
            report "SLT Case 2 Failed: Expected zero flag '1'" severity error;

        wait;
    end process;

end behavior;
