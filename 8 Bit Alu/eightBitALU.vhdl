LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitALU IS
    PORT(
        A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        ALU_control : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 0 for ADD, 1 for SUB, 2 for AND, 3 for OR, 4 for set less than
        zero : OUT STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END eightBitALU;

ARCHITECTURE Structural OF eightBitALU IS

    -- define sub-components and signals
    COMPONENT eightBitCLA IS
        PORT(
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            sub : IN STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    component twoBy8To8Mux IS
        PORT(
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            sel : IN STD_LOGIC;
            result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END component;

    component sorter IS
        PORT(
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            enable : IN STD_LOGIC;
            C : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            D : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END component;

    signal and_result : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal or_result : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal mathematical_result : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal logical_output : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal arithmetic_output : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal logical_sel : STD_LOGIC;
    signal arithmetic_sel : STD_LOGIC;
    signal to_sub_or_not_to_sub : STD_LOGIC;
    signal set_less_than : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal final: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal top_level_sel : STD_LOGIC;
    signal arithmetic_a, arithmetic_b : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    -- select logical operation

    and_result <= A AND B;
    or_result <= A OR B;
    logical_sel <= ALU_control(0);  -- AND is even and OR is ODD

    logical_select_mux: twoBy8To8Mux PORT MAP(
        A => and_result,
        B => or_result,
        sel => logical_sel,
        result => logical_output
    );

    -- perform arithmetic operation

    to_sub_or_not_to_sub <= ALU_control(0) or ALU_control(2);  -- subbing for sub and set less than

    sorting: sorter PORT MAP(
        A => A,
        B => B,
        enable => ALU_control(0),
        C => arithmetic_a,
        D => arithmetic_b
    );

    arithmetic_unit: eightBitCLA PORT MAP(
        A => arithmetic_a,
        B => arithmetic_b,
        sub => to_sub_or_not_to_sub,
        sum => mathematical_result,
        cout => open
    );

    -- calculate set less than
    set_less_than <= (7 downto 1 => '0') & mathematical_result(7); -- A less than B if sign bit is negative after subtraction

    -- determine arithmetic selection
    arithmetic_sel <= ALU_control(2);  -- select set less than if ALU_control(2) is high

    -- select arithmetic output
    arithmetic_select_mux: twoBy8To8Mux PORT MAP(
        A => mathematical_result,
        B => set_less_than,
        sel => arithmetic_sel,
        result => arithmetic_output
    );

    -- select between logical and arithmetic output
    top_level_mux: twoBy8To8Mux PORT MAP(
        A => arithmetic_output,
        B => logical_output,
        sel => ALU_control(1),  -- and and or are the only options with ALU_control(1) high
        result => final
    );

    zero <= not (final(7) or final(6) or final(5) or final(4) or final(3) or final(2) or final(1) or final(0));
    result <= final;
END Structural;