LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_1164.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;

LIBRARY lpp;
USE lpp.iir_filter.ALL;

ENTITY testbench_ms IS

END testbench_ms;

ARCHITECTURE tb OF testbench_ms IS
  -----------------------------------------------------------------------------
  -- COMPONENT ----------------------------------------------------------------
  -----------------------------------------------------------------------------
  COMPONENT lpp_lfr_apbreg_tb
    GENERIC (
      pindex : INTEGER;
      paddr  : INTEGER;
      pmask  : INTEGER);
    PORT (
      HCLK                 : IN  STD_ULOGIC;
      HRESETn              : IN  STD_ULOGIC;
      apbi                 : IN  apb_slv_in_type;
      apbo                 : OUT apb_slv_out_type;
      MEM_IN_SM_wData      : OUT STD_LOGIC_VECTOR(16*2*5-1 DOWNTO 0);
      MEM_IN_SM_wen        : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      MEM_IN_SM_Full_out   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      MEM_IN_SM_Empty_out  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      MEM_IN_SM_locked_out : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      MEM_OUT_SM_ren       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      MEM_OUT_SM_Data_out  : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
      MEM_OUT_SM_Full      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      MEM_OUT_SM_Full_2    : IN  STD_LOGIC;
      MEM_OUT_SM_Empty     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_lfr_ms_tb
    GENERIC (
      Mem_use : INTEGER);
    PORT (
      clk                    : IN  STD_LOGIC;
      rstn                   : IN  STD_LOGIC;
      MEM_IN_SM_wData        : IN  STD_LOGIC_VECTOR(16*2*5-1 DOWNTO 0);
      MEM_IN_SM_wen          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      MEM_IN_SM_Full_out     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      MEM_IN_SM_Empty_out    : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      MEM_IN_SM_locked_out   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      MEM_OUT_SM_Read        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      MEM_OUT_SM_Data_out    : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      MEM_OUT_SM_Full_pad    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      MEM_OUT_SM_Full_pad_2  : OUT STD_LOGIC;
      MEM_OUT_SM_Empty_pad   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      error_input_fifo_write : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      observation_vector_0   : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      observation_vector_1   : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
  END COMPONENT;
  
  -----------------------------------------------------------------------------
  -- SIGNAL -------------------------------------------------------------------
  -----------------------------------------------------------------------------
  SIGNAL clk  : STD_LOGIC := '0';
  SIGNAL rstn : STD_LOGIC := '0';
  SIGNAL apbi : apb_slv_in_type;
  SIGNAL apbo : apb_slv_out_type;
  
  SIGNAL MEM_OUT_SM_ren       : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Data_out  : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Full_pad  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Full_pad_2  : STD_LOGIC;
  SIGNAL MEM_OUT_SM_Empty_pad : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL MEM_IN_SM_wData      :  STD_LOGIC_VECTOR(16*2*5-1 DOWNTO 0);
  SIGNAL MEM_IN_SM_wen        :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_Full_out   :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_Empty_out  :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_locked_out :  STD_LOGIC_VECTOR(4 DOWNTO 0);


  -----------------------------------------------------------------------------
  -- FFT
  -----------------------------------------------------------------------------
  TYPE fft_tab_type IS ARRAY (255 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_1_re : fft_tab_type;
  SIGNAL fft_1_im : fft_tab_type;
  SIGNAL fft_2_re : fft_tab_type;
  SIGNAL fft_2_im : fft_tab_type;
  SIGNAL fft_3_re : fft_tab_type;
  SIGNAL fft_3_im : fft_tab_type;
  SIGNAL fft_4_re : fft_tab_type;
  SIGNAL fft_4_im : fft_tab_type;
  SIGNAL fft_5_re : fft_tab_type;
  SIGNAL fft_5_im : fft_tab_type;

  SIGNAL counter_1 : INTEGER;
  SIGNAL counter_2 : INTEGER;
  SIGNAL counter_3 : INTEGER;
  SIGNAL counter_4 : INTEGER;
  SIGNAL counter_5 : INTEGER;
  
  
BEGIN  -- tb

  
  clk <= NOT clk AFTER 20 ns;
  rstn <= '1' AFTER 100 ns;

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      all_data: FOR i IN 255 DOWNTO 0 LOOP
        fft_1_re(I) <= (OTHERS => '0');
        fft_1_im(I) <= (OTHERS => '0');
        fft_2_re(I) <= (OTHERS => '0');
        fft_2_im(I) <= (OTHERS => '0');
        fft_3_re(I) <= (OTHERS => '0');
        fft_3_im(I) <= (OTHERS => '0');
        fft_4_re(I) <= (OTHERS => '0');
        fft_4_im(I) <= (OTHERS => '0');
        fft_5_re(I) <= (OTHERS => '0');
        fft_5_im(I) <= (OTHERS => '0');
      END LOOP all_data;
      fft_1_re(8*0)   <= x"0fff";
      fft_1_im(8*0)   <= x"0010";
      fft_2_re(8*1)   <= x"0010";
      fft_2_im(8*1+1) <= x"0040";
      fft_3_re(8*2)   <= x"0010";
      fft_3_im(8*3)   <= x"0100";
      fft_4_re(8*4)   <= x"0001";
      fft_4_im(8*5)   <= x"0111";
      fft_5_re(8*6)   <= x"0033";
      fft_5_im(8*7)   <= x"0444";  

      counter_1 <= 0;
      counter_2 <= 0;
      counter_3 <= 0;
      counter_4 <= 0;
      counter_5 <= 0;  

      MEM_IN_SM_wen <= (OTHERS => '1');
      MEM_OUT_SM_ren <= (OTHERS => '1');
      
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF MEM_IN_SM_locked_out(0) = '0' AND MEM_IN_SM_Full_out(0) = '0' THEN
        counter_1                     <= counter_1 + 1;
        MEM_IN_SM_wData(15 DOWNTO  0) <= fft_1_re(counter_1);
        MEM_IN_SM_wData(31 DOWNTO 16) <= fft_1_im(counter_1);
        MEM_IN_SM_wen(0)              <= '0';
      ELSE
        counter_1 <= 0;
        MEM_IN_SM_wData(31 DOWNTO 0) <= (OTHERS => 'X'); 
        MEM_IN_SM_wen(0)             <= '1';
      END IF;

    END IF;
  END PROCESS;

  
  

  
  
  

-------------------------------------------------------------------------------
-- MS ------------------------------------------------------------------------
-------------------------------------------------------------------------------

  --lpp_lfr_apbreg_1 : lpp_lfr_apbreg_tb
  --  GENERIC MAP (
  --    pindex => 15,
  --    paddr  => 15,
  --    pmask  => 16#fff#)
  --  PORT MAP (
  --    HCLK    => clk,
  --    HRESETn => rstn,
  --    apbi    => apbi,
  --    apbo    => apbo,

  --    MEM_IN_SM_wData      => MEM_IN_SM_wData,
  --    MEM_IN_SM_wen        => MEM_IN_SM_wen,
  --    MEM_IN_SM_Full_out   => MEM_IN_SM_Full_out,
  --    MEM_IN_SM_Empty_out  => MEM_IN_SM_Empty_out,
  --    MEM_IN_SM_locked_out => MEM_IN_SM_locked_out,
      
  --    MEM_OUT_SM_ren       => MEM_OUT_SM_ren ,    
  --    MEM_OUT_SM_Data_out  => MEM_OUT_SM_Data_out ,
  --    MEM_OUT_SM_Full      => MEM_OUT_SM_Full_pad ,
  --    MEM_OUT_SM_Full_2    => MEM_OUT_SM_Full_pad_2 ,
  --    MEM_OUT_SM_Empty     => MEM_OUT_SM_Empty_pad);

  lpp_lfr_ms_tb_1 : lpp_lfr_ms_tb
    GENERIC MAP (
      Mem_use => use_CEL)
    PORT MAP (
      clk             => clk,
      rstn            => rstn,
      
      MEM_IN_SM_wData      => MEM_IN_SM_wData,
      MEM_IN_SM_wen        => MEM_IN_SM_wen,
      MEM_IN_SM_Full_out   => MEM_IN_SM_Full_out,
      MEM_IN_SM_Empty_out  => MEM_IN_SM_Empty_out,
      MEM_IN_SM_locked_out => MEM_IN_SM_locked_out,
      
      MEM_OUT_SM_Read       => MEM_OUT_SM_ren ,    
      MEM_OUT_SM_Data_out   => MEM_OUT_SM_Data_out ,
      MEM_OUT_SM_Full_pad   => MEM_OUT_SM_Full_pad ,
      MEM_OUT_SM_Full_pad_2 => MEM_OUT_SM_Full_pad_2 ,
      MEM_OUT_SM_Empty_pad  => MEM_OUT_SM_Empty_pad,

      error_input_fifo_write => OPEN,
      observation_vector_0   => OPEN,
      observation_vector_1   => OPEN);

  -----------------------------------------------------------------------------
END tb;
