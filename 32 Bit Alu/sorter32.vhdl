library ieee;
use ieee.std_logic_1164.all;

entity sorter32 is
    port (
        A      : in  std_logic_vector(31 downto 0);
        B      : in  std_logic_vector(31 downto 0);
        enable : in  std_logic;
        C      : out std_logic_vector(31 downto 0);  -- greater of A and B when enabled, else A
        D      : out std_logic_vector(31 downto 0)   -- lesser of A and B when enabled, else B
    );
end sorter32;

architecture Structural of sorter32 is

    component thirtyTwoBitComparator is
        port (
            A      : in  std_logic_vector(31 downto 0);
            B      : in  std_logic_vector(31 downto 0);
            A_gt_B : out std_logic;
            A_eq_B : out std_logic
        );
    end component;

    component twoBy32To32Mux is
        port (
        A      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        B      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        sel    : IN  STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    end component;

    signal gt, eq         : std_logic;  -- gt: '1' if A > B
    signal gt_bar         : std_logic;
    signal control_c, control_d : std_logic;  -- mux select signals

begin

    gt_bar <= not gt;

    -- When enable is high, use sorting logic; when low, force pass-through
    control_c <= gt_bar and enable; -- for mux_greater: '0' selects A, '1' selects B
    control_d <= gt or (not enable); -- for mux_lesser: '0' selects A, '1' selects B

    -- Compare A and B using the 32-bit comparator
    comp_inst: thirtyTwoBitComparator
        port map (
            A      => A,
            B      => B,
            A_gt_B => gt,
            A_eq_B => eq
        );

    -- Greater mux: if enable is high, select the greater of A and B; else pass A.
    mux_greater: twoBy32To32Mux
        port map (
            A      => A,
            B      => B,
            sel    => control_c,
            result => C
        );

    -- Lesser mux: if enable is high, select the lesser of A and B; else pass B.
    mux_lesser: twoBy32To32Mux
        port map (
            A      => A,
            B      => B,
            sel    => control_d,
            result => D
        );

end Structural;
