LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY thirtyTwoBitALU IS
    PORT(
        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_control : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 0 for ADD, 1 for SUB, 2 for AND, 3 for OR, 4 for set less than
        zero : OUT STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END thirtyTwoBitALU;

ARCHITECTURE Structural OF thirtyTwoBitALU IS

    -- define sub-components and signals
    COMPONENT thirtyTwoBitCLA IS
        PORT(
            A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sub : IN STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    component twoBy32To32Mux IS
        PORT(
            A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sel : IN STD_LOGIC;
            result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END component;

    component or32 IS
        PORT(
            in_vec : in  std_logic_vector(31 downto 0);
            out_or : out std_logic
        );
    END component;

    signal and_result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal or_result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal mathematical_result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal logical_output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal arithmetic_output : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal logical_sel : STD_LOGIC;
    signal arithmetic_sel : STD_LOGIC;
    signal to_sub_or_not_to_sub : STD_LOGIC;
    signal set_less_than : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal final: STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal not_zero : STD_LOGIC;
    signal top_level_sel : STD_LOGIC;

BEGIN

    -- select logical operation

    and_result <= A AND B;
    or_result <= A OR B;
    logical_sel <= ALU_control(0);  -- AND is even and OR is ODD

    logical_select_mux: twoBy32To32Mux PORT MAP(
        A => and_result,
        B => or_result,
        sel => logical_sel,
        result => logical_output
    );

    -- perform arithmetic operation

    to_sub_or_not_to_sub <= ALU_control(0) or ALU_control(2);  -- subbing for sub and set less than

    arithmetic_unit: thirtyTwoBitCLA PORT MAP(
        A => A,
        B => B,
        sub => to_sub_or_not_to_sub,
        sum => mathematical_result,
        cout => open
    );

    -- calculate set less than
    set_less_than <= (31 downto 1 => '0') & mathematical_result(31); -- A less than B if sign bit is negative after subtraction

    -- determine arithmetic selection
    arithmetic_sel <= ALU_control(2);  -- select set less than if ALU_control(2) is high

    -- select arithmetic output
    arithmetic_select_mux: twoBy32To32Mux PORT MAP(
        A => mathematical_result,
        B => set_less_than,
        sel => arithmetic_sel,
        result => arithmetic_output
    );

    -- select between logical and arithmetic output
    top_level_mux: twoBy32To32Mux PORT MAP(
        A => arithmetic_output,
        B => logical_output,
        sel => ALU_control(1),  -- and and or are the only options with ALU_control(1) high
        result => final
    );

    -- determine if result is zero
    zero_calc: or32 PORT MAP(
        in_vec => final,
        out_or => not_zero
    );

    zero <= not not_zero;
    result <= final;
END Structural;