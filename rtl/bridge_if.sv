interface bridge_if(input bit clk);
             
	logic Hresetn;
	logic Hwrite;
	logic Hreadyin;
	logic Hreadyout;
	logic [1:0] Htrans;
	logic [1:0] Hresp;
	logic [31:0] Hwdata;
	logic [31:0] Hrdata;
	logic [31:0] Haddr;
//	logic Hselapbif;
	logic [2:0]Hburst;
	logic [2:0]Hsize;
	logic [7:0]length;
	
	logic  Penable;
	logic  Pwrite;
	logic [3:0]Pselx;
	logic [31:0]Pwdata;
	logic [31:0] Prdata;
	logic [31:0]Paddr;
	
clocking ahb_drv_cb@(posedge clk);	
	default input #1 output #1;

	output Hresetn;
	output Hwrite;
	output Htrans;
	output Hwdata;
	output Hreadyin;
	output Haddr;
	output Hburst;
	output Hsize;
	input Hreadyout;

endclocking

clocking ahb_mon_cb@(posedge clk);	
	default input#1 output#1;
	
	input Haddr;
	input Hburst;
	input Htrans; 
	input Hsize;
	input Hwrite;
	input Hresetn;
	input Hwdata;
	input Hreadyin;	
	input Hrdata;
	input Hresp;      
	input Hreadyout;  
	
endclocking



clocking apb_drv_cb @(posedge clk);
	default input#1 output#1;
	input Pwrite;
	input Pselx;
	output Prdata;  
endclocking


clocking apb_mon_cb @(posedge clk);
	default input#1 output#1;
	
	input Penable;
	input Pwrite;
	input Pwdata;
	input Paddr;
	input Pselx;
	input Prdata;
	
endclocking



modport  AHB_DRV_MP ( clocking ahb_drv_cb);
modport  AHB_MON_MP ( clocking ahb_mon_cb);
modport  APB_DRV_MP ( clocking apb_drv_cb);
modport  APB_MON_MP ( clocking apb_mon_cb);

endinterface	 