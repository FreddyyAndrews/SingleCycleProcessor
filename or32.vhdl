library IEEE;
use IEEE.std_logic_1164.all;

entity or32 is
    port (
        in_vec : in  std_logic_vector(31 downto 0);
        out_or : out std_logic
    );
end or32;

architecture structural of or32 is
    -- Intermediate signals for each level of the OR tree.
    signal or_level1 : std_logic_vector(15 downto 0);
    signal or_level2 : std_logic_vector(7 downto 0);
    signal or_level3 : std_logic_vector(3 downto 0);
    signal or_level4 : std_logic_vector(1 downto 0);

begin

    -- Level 1: OR adjacent pairs of the 32-bit input (32 → 16)
    gen_or1: for i in 0 to 15 generate
        or_level1(i) <= in_vec(2*i) or in_vec(2*i+1);
    end generate;

    -- Level 2: OR adjacent pairs of level 1 outputs (16 → 8)
    gen_or2: for i in 0 to 7 generate
        or_level2(i) <= or_level1(2*i) or or_level1(2*i+1);
    end generate;

    -- Level 3: OR adjacent pairs of level 2 outputs (8 → 4)
    gen_or3: for i in 0 to 3 generate
        or_level3(i) <= or_level2(2*i) or or_level2(2*i+1);
    end generate;

    -- Level 4: OR adjacent pairs of level 3 outputs (4 → 2)
    gen_or4: for i in 0 to 1 generate
        or_level4(i) <= or_level3(2*i) or or_level3(2*i+1);
    end generate;

    -- Output the final OR reduction.
    out_or <= or_level4(0) or or_level4(1);

end structural;
