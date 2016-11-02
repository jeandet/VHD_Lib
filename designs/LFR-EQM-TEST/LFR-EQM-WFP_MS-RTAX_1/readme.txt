leon3_soc :
	ENABLE_AHB_UART = 0 (disabled)
	ENABLE_APB_UART = 0 (disabled)
	FPU_NETLIST     = 0 (enabled)

apb_lfr_management :
	lfr_cal_driver (enabled)

top :
	LFR_rstn <= LFR_soft_rstn AND rstn_25;

GRSPW :
        ft		= 1 (enabled)
