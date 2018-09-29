
// AHB-Lite  SDRAM controller HW test for Terasic de10-lite
module de1_soc(
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		     [7:0]		VGA_B,
	output		     [7:0]		VGA_G,

	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	
	output		          		VGA_VS,

	output		          		VGA_BLANK_N,
	output		          		VGA_CLK,
	output		          		VGA_SYNC_N,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		 GPIO

);



//=======================================================
//  REG/WIRE declarations
//=======================================================


	//AHB-Lite
	 wire                        HCLK;    
    wire                        HRESETn;
    wire  [ 31 : 0 ]            HADDR;      //  Address
    wire  [  2 : 0 ]            HBURST;     //  Burst Operation (0 -SINGLE, 2 -WRAP4)
    wire                        HSEL;       //  Chip select
    wire  [  2 : 0 ]            HSIZE;      //  Transfer Size (0 -x8,   1 -x16,     2 -x32)
    wire  [  1 : 0 ]            HTRANS;     //  Transfer Type (0 -IDLE, 2 -NONSEQ,  3-SEQ)
    wire  [ 31 : 0 ]            HWDATA;     //  Write data
    wire                        HWRITE;     //  Write request
    wire  [ 31 : 0 ]            HRDATA;     //  Read data
    wire                        HREADY;     //  Indicate the previous transfer is complete
    wire                        HRESP;      //  0 is OKAY, 1 is ERROR

	//debug
	wire  [ 31 : 0 ]            ERRCOUNT;   //err counter
    wire  [  7 : 0 ]            CHKCOUNT;   //check counter
    wire  [ 31 : 0 ]            STARTADDR;  //chech start addr
    

//=======================================================
//  Structural coding
//=======================================================

    //wire clk200;
	sdram_pll u0 (
		.ref_clk_clk        (CLOCK_50),        	//      ref_clk.clk
		.ref_reset_reset    (0),   				 	//    ref_reset.reset
		.sys_clk_clk        (HCLK),        				//      sys_clk.clk
		.sdram_clk_clk      (DRAM_CLK),      		//    sdram_clk.clk
		.reset_source_reset ()  						// reset_source.reset
	);
	
	
	
	
	 
	assign HRESETn = KEY [0];
    assign STARTADDR = { { 20 { 1'b0 }}, SW, 2'b0 };

    assign LEDR[9] = ~DRAM_CKE;

	ahb_lite_rw_master
    #(
        .ADDR_INCREMENT ( 32'h4),
        .DELAY_BITS     ( 10        ),
        .INCREMENT_CNT  ( 32'h100_0000-1),  //go through all the 64MB address
        .READ_ITER_CNT  ( 10   )
    )
    master 
    (
        .HCLK       (   HCLK        ),
        .HRESETn    (   HRESETn     ),
        .HADDR      (   HADDR       ),
        .HBURST     (   HBURST      ),
        .HSEL       (   HSEL        ),
        .HSIZE      (   HSIZE       ),
        .HTRANS     (   HTRANS      ),
        .HWDATA     (   HWDATA      ),
        .HWRITE     (   HWRITE      ),
        .HRDATA     (   HRDATA      ),
        .HREADY     (   HREADY      ),
        .HRESP      (   HRESP       ),

        .ERRCOUNT   (   ERRCOUNT    ),
        .CHKCOUNT   (   CHKCOUNT    ),
        .S_WRITE    (   LEDR[0]     ),
        .S_CHECK    (   LEDR[1]     ),
        .S_SUCCESS  (   LEDR[2]     ),
        .S_FAILED   (   LEDR[3]     ),
        .STARTADDR  (   STARTADDR   )
    );

	ahb_lite_sdram 
    #(
        //for T=20ns
        .DELAY_nCKE         (10000),
        .DELAY_tREF         (390),
        .DELAY_tRP          (0),
        .DELAY_tRFC         (2),
        .DELAY_tMRD         (0),
        .DELAY_tRCD         (0),
        .DELAY_tCAS         (1),
        .DELAY_afterREAD    (0),
        .DELAY_afterWRITE   (2),
        .COUNT_initAutoRef  (8)
    ) 
    mem
    (
        .HCLK       (   HCLK        ),
        .HRESETn    (   HRESETn     ),
        .HADDR      (   HADDR       ),
        .HBURST     (   HBURST      ),
        .HSEL       (   HSEL        ),
        .HSIZE      (   HSIZE       ),
        .HTRANS     (   HTRANS      ),
        .HWDATA     (   HWDATA      ),
        .HWRITE     (   HWRITE      ),
        .HRDATA     (   HRDATA      ),
        .HREADY     (   1'b1        ),
        .HREADYOUT  (   HREADY      ),
        .HRESP      (   HRESP       ),

        .CKE        (   DRAM_CKE                ),
        .CSn        (   DRAM_CS_N               ),
        .RASn       (   DRAM_RAS_N              ),
        .CASn       (   DRAM_CAS_N              ),
        .WEn        (   DRAM_WE_N               ),
        .ADDR       (   DRAM_ADDR               ),
        .BA         (   DRAM_BA                 ),
        .DQ         (   DRAM_DQ                 ),
        .DQM        (   {DRAM_UDQM, DRAM_LDQM}  )
    );

//	assign { HEX5[7], HEX4[7], HEX3[7], HEX2[7], HEX1[7], HEX0[7] } = 6'b101111;

	seven_segment digit_5 ( CHKCOUNT [ 7:4 ] , HEX5 [ 6:0] );
    seven_segment digit_4 ( CHKCOUNT [ 3:0 ] , HEX4 [ 6:0] );
    seven_segment digit_3 ( ERRCOUNT [15:12] , HEX3 [ 6:0] );
    seven_segment digit_2 ( ERRCOUNT [11:8 ] , HEX2 [ 6:0] );
    seven_segment digit_1 ( ERRCOUNT [ 7:4 ] , HEX1 [ 6:0] );
    seven_segment digit_0 ( ERRCOUNT [ 3:0 ] , HEX0 [ 6:0] );

endmodule
