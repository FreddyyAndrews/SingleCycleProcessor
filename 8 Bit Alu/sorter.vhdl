library ieee;
use ieee.std_logic_1164.all;

entity sorter is
    port (
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        enable : in  std_logic;
        C      : out std_logic_vector(7 downto 0);  -- greater of A and B when enabled, else A
        D      : out std_logic_vector(7 downto 0)   -- lesser of A and B when enabled, else B
    );
end sorter;

architecture Structural of sorter is

    component eightBitComparator is
        port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            A_gt_B : out std_logic;
            A_eq_B : out std_logic
        );
    end component;

    component twoBy8To8Mux is
        port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            sel    : in  std_logic;
            result : out std_logic_vector(7 downto 0)
        );
    end component;

    signal gt, eq      : std_logic;  -- gt: '1' if A > B
    signal gt_bar      : std_logic;
    signal control_c, control_d : std_logic;  -- mux select signals

begin

    gt_bar <= not gt;

    -- When enable is high, use sorting logic; when low, force pass-through
    control_c <= gt_bar and enable; -- for mux_greater: '0' selects A, '1' selects B
    control_d <= gt or (not enable); -- for mux_lesser: '0' selects A, '1' selects B

    -- Compare A and B
    comp_inst: eightBitComparator
        port map (
            A      => A,
            B      => B,
            A_gt_B => gt,
            A_eq_B => eq
        );

    -- Greater mux: if enable is high, select the greater of A and B; else pass A.
    mux_greater: twoBy8To8Mux
        port map (
            A      => A,
            B      => B,
            sel    => control_c,
            result => C
        );

    -- Lesser mux: if enable is high, select the lesser of A and B; else pass B.
    mux_lesser: twoBy8To8Mux
        port map (
            A      => A,
            B      => B,
            sel    => control_d,
            result => D
        );

end Structural;
