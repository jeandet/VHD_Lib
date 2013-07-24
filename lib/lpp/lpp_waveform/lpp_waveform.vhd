LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

LIBRARY lpp;
USE lpp.lpp_waveform_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

ENTITY lpp_waveform IS
  
  GENERIC (
    hindex                 : INTEGER := 2;
    tech                   : INTEGER := inferred;
    data_size              : INTEGER := 160;
    nb_burst_available_size : INTEGER := 11;
    nb_snapshot_param_size : INTEGER := 11;
    delta_snapshot_size    : INTEGER := 16;
    delta_f2_f0_size       : INTEGER := 10;
    delta_f2_f1_size       : INTEGER := 10);

  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    
    -- AMBA AHB Master Interface
    AHB_Master_In     : IN  AHB_Mst_In_Type;
    AHB_Master_Out    : OUT AHB_Mst_Out_Type;

    coarse_time_0 : IN STD_LOGIC;
    
    --config
    delta_snapshot    : IN STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
    delta_f2_f1       : IN STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
    delta_f2_f0       : IN STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
    
    enable_f0 : IN STD_LOGIC;
    enable_f1 : IN STD_LOGIC;
    enable_f2 : IN STD_LOGIC;
    enable_f3 : IN STD_LOGIC;

    burst_f0 : IN STD_LOGIC;
    burst_f1 : IN STD_LOGIC;
    burst_f2 : IN STD_LOGIC;

    nb_burst_available : IN STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
    nb_snapshot_param : IN STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
    status_full       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_ack   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_full_err   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    status_new_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- New data f(i) before the current data is write by dma
    addr_data_f0      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f1      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f2      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    addr_data_f3      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

   data_f0_in : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
   data_f1_in : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
   data_f2_in : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
   data_f3_in : IN STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);

   data_f0_in_valid : IN  STD_LOGIC;
   data_f1_in_valid : IN  STD_LOGIC;
   data_f2_in_valid : IN  STD_LOGIC;
   data_f3_in_valid : IN  STD_LOGIC
    );

END lpp_waveform;

ARCHITECTURE beh OF lpp_waveform IS
  SIGNAL start_snapshot_f0 : STD_LOGIC;
  SIGNAL start_snapshot_f1 : STD_LOGIC;
  SIGNAL start_snapshot_f2 : STD_LOGIC;

  SIGNAL data_f0_out : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f1_out : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f2_out : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);
  SIGNAL data_f3_out : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);

  SIGNAL data_f0_out_valid :  STD_LOGIC;
  SIGNAL data_f1_out_valid :  STD_LOGIC;
  SIGNAL data_f2_out_valid :  STD_LOGIC;
  SIGNAL data_f3_out_valid :  STD_LOGIC;
  SIGNAL nb_snapshot_param_more_one : STD_LOGIC_VECTOR(nb_snapshot_param_size DOWNTO 0);

  --
  SIGNAL valid_in  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL valid_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL valid_ack : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL ready     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL ready_arb     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_wen     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_wen     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wdata         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  --
  SIGNAL data_ren     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_ren     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL rdata         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
BEGIN  -- beh

  lpp_waveform_snapshot_controler_1: lpp_waveform_snapshot_controler
    GENERIC MAP (
      delta_snapshot_size => delta_snapshot_size,
      delta_f2_f0_size    => delta_f2_f0_size,
      delta_f2_f1_size    => delta_f2_f1_size)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      delta_snapshot    => delta_snapshot,
      delta_f2_f1       => delta_f2_f1,
      delta_f2_f0       => delta_f2_f0,
      coarse_time_0     => coarse_time_0,
      data_f0_in_valid  => data_f0_in_valid,
      data_f2_in_valid  => data_f2_in_valid,
      start_snapshot_f0 => start_snapshot_f0,
      start_snapshot_f1 => start_snapshot_f1,
      start_snapshot_f2 => start_snapshot_f2);
  
  lpp_waveform_snapshot_f0 : lpp_waveform_snapshot
    GENERIC MAP (
      data_size              => data_size,
      nb_snapshot_param_size => nb_snapshot_param_size)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      enable            => enable_f0,
      burst_enable      => burst_f0,
      nb_snapshot_param => nb_snapshot_param,
      start_snapshot    => start_snapshot_f0,
      data_in           => data_f0_in,
      data_in_valid     => data_f0_in_valid,
      data_out          => data_f0_out,
      data_out_valid    => data_f0_out_valid);

  nb_snapshot_param_more_one <= ('0' & nb_snapshot_param) + 1;
  
  lpp_waveform_snapshot_f1 : lpp_waveform_snapshot
    GENERIC MAP (
      data_size              => data_size,
      nb_snapshot_param_size => nb_snapshot_param_size+1)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      enable            => enable_f1,
      burst_enable      => burst_f1,
      nb_snapshot_param => nb_snapshot_param_more_one,
      start_snapshot    => start_snapshot_f1,
      data_in           => data_f1_in,
      data_in_valid     => data_f1_in_valid,
      data_out          => data_f1_out,
      data_out_valid    => data_f1_out_valid);

  lpp_waveform_snapshot_f2 : lpp_waveform_snapshot
    GENERIC MAP (
      data_size              => data_size,
      nb_snapshot_param_size => nb_snapshot_param_size+1)
    PORT MAP (
      clk               => clk,
      rstn              => rstn,
      enable            => enable_f2,
      burst_enable      => burst_f2,
      nb_snapshot_param => nb_snapshot_param_more_one,
      start_snapshot    => start_snapshot_f2,
      data_in           => data_f2_in,
      data_in_valid     => data_f2_in_valid,
      data_out          => data_f2_out,
      data_out_valid    => data_f2_out_valid);

  lpp_waveform_burst_f3: lpp_waveform_burst
    GENERIC MAP (
      data_size => data_size)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      enable         => enable_f3,
      data_in        => data_f3_in,
      data_in_valid  => data_f3_in_valid,
      data_out       => data_f3_out,
      data_out_valid => data_f3_out_valid);


  valid_in <= data_f3_out_valid & data_f2_out_valid & data_f1_out_valid & data_f0_out_valid;
  
  all_input_valid: FOR i IN 3 DOWNTO 0 GENERATE
    lpp_waveform_dma_gen_valid_I: lpp_waveform_dma_gen_valid
      PORT MAP (
        HCLK      => clk,
        HRESETn   => rstn,
        valid_in  => valid_in(I),
        ack_in    => valid_ack(I),
        valid_out => valid_out(I),
        error     => status_new_err(I));
  END GENERATE all_input_valid;

  lpp_waveform_fifo_arbiter_1: lpp_waveform_fifo_arbiter
    GENERIC MAP (tech => tech)
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      data_f0_valid  => valid_out(0),
      data_f1_valid  => valid_out(1),
      data_f2_valid  => valid_out(2),
      data_f3_valid  => valid_out(3),
      
      data_valid_ack => valid_ack,
      
      data_f0        => data_f0_out,
      data_f1        => data_f1_out,
      data_f2        => data_f2_out,
      data_f3        => data_f3_out,
      
      ready          => ready_arb,
      time_wen       => time_wen,
      data_wen       => data_wen,
      data           => wdata);

  ready_arb <= NOT ready;
  
  lpp_waveform_fifo_1: lpp_waveform_fifo
    GENERIC MAP (tech => tech)
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      ready    => ready,
      time_ren => time_ren,             -- todo
      data_ren => data_ren,             -- todo
      rdata    => rdata,                -- todo
      
      time_wen => time_wen,
      data_wen => data_wen,
      wdata    => wdata);

  --time_ren <= (OTHERS => '1');
  --data_ren <= (OTHERS => '1');
 
  pp_waveform_dma_1: lpp_waveform_dma
   GENERIC MAP (
     data_size              => data_size,
     tech                   => tech,
     hindex                 => hindex,
     nb_burst_available_size => nb_burst_available_size)
   PORT MAP (
     HCLK              => clk,                 
     HRESETn           => rstn,                
     AHB_Master_In     => AHB_Master_In,       
     AHB_Master_Out    => AHB_Master_Out,
     data_ready        => ready,
     data              => rdata,
     data_data_ren     => data_ren,
     data_time_ren     => time_ren,
     --data_f0_in        => data_f0_out,         
     --data_f1_in        => data_f1_out,         
     --data_f2_in        => data_f2_out,         
     --data_f3_in        => data_f3_out,         
     --data_f0_in_valid  => data_f0_out_valid,   
     --data_f1_in_valid  => data_f1_out_valid,   
     --data_f2_in_valid  => data_f2_out_valid,   
     --data_f3_in_valid  => data_f3_out_valid,   
     nb_burst_available => nb_burst_available,   
     status_full       => status_full,
     status_full_ack   => status_full_ack,
     status_full_err   => status_full_err,
     addr_data_f0      => addr_data_f0,
     addr_data_f1      => addr_data_f1,
     addr_data_f2      => addr_data_f2,
     addr_data_f3      => addr_data_f3);

END beh;
