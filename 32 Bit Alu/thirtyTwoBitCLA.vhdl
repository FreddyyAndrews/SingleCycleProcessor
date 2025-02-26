library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------
-- 32-bit CLA with Subtraction
-------------------------------------------

entity thirtyTwoBitCLA is
    port (
        A    : in std_logic_vector(31 downto 0);  -- First input
        B    : in std_logic_vector(31 downto 0);  -- Second input
        sub  : in std_logic;                     -- Subtraction signal (1 = subtraction, 0 = addition)
        sum  : out std_logic_vector(31 downto 0); -- Sum output
        cout : out std_logic                    -- Carry-out
    );
end thirtyTwoBitCLA;

architecture structural of thirtyTwoBitCLA is

    signal cn          : std_logic_vector(31 downto 0); -- Carry signals
    signal gn          : std_logic_vector(31 downto 0); -- Generate signals
    signal pn          : std_logic_vector(31 downto 0); -- Propagate signals
    signal B_xor_sub  : std_logic_vector(31 downto 0); -- Modified B based on sub signal

begin

    -- XOR B with the sub signal for two's complement subtraction
    GEN_B_xor_sub: for i in 0 to 31 generate
        B_xor_sub(i) <= B(i) xor sub;
    end generate GEN_B_xor_sub;

    -- Generate signals (gn = A and B_xor_sub)
    GEN_gn: for i in 0 to 31 generate
        gn(i) <= A(i) and B_xor_sub(i);
    end generate GEN_gn;

    -- Propagate signals (pn = A or B_xor_sub)
    GEN_pn: for i in 0 to 31 generate
        pn(i) <= A(i) or B_xor_sub(i);
    end generate GEN_pn;
    
    -- Compute carry for the first bit (sub acts as the initial carry-in for subtraction)
    cn(0) <= gn(0) or (sub and pn(0));

    -- Compute carry for the remaining bits
    GEN_cn: for i in 1 to 31 generate
        cn(i) <= gn(i) or (cn(i-1) and pn(i));
    end generate GEN_cn;

    -- Compute sum for the LSB
    sum(0) <= A(0) xor B_xor_sub(0) xor sub;

    -- Compute sum for the remaining bits
    GEN_sum: for i in 1 to 31 generate
        sum(i) <= A(i) xor B_xor_sub(i) xor cn(i-1);
    end generate GEN_sum;

    -- Final carry-out
    cout <= cn(31);

end architecture structural;
