class ahb_driver extends uvm_driver #(ahb_xtn);
 `uvm_component_utils(ahb_driver)
 
 virtual bridge_if.AHB_DRV_MP vif;
 ahb_agt_config ahb_cfg;
 
 extern function new(string name="ahb_driver",uvm_component parent);
 extern function void build_phase(uvm_phase phase);
 extern function void connect_phase(uvm_phase phase);
 extern function void end_of_elaboration_phase(uvm_phase phase);
 extern task run_phase(uvm_phase phase);
 extern task send_to_dut(ahb_xtn xtnh);
endclass

function ahb_driver::new(string name="ahb_driver",uvm_component parent);
 super.new(name,parent);
endfunction

function void ahb_driver::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",ahb_cfg))
 `uvm_fatal(get_full_name,"error at getting") 
endfunction

function void ahb_driver::connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 vif=ahb_cfg.vif;
endfunction

function void ahb_driver::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction

task ahb_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);

  @(vif.ahb_drv_cb);
   vif.ahb_drv_cb.Hresetn<='b0;  
  
  repeat(2)
  @(vif.ahb_drv_cb);
  vif.ahb_drv_cb.Hresetn<='b1;

  
  wait(vif.ahb_drv_cb.Hreadyout);
  forever
     begin   
	 seq_item_port.get_next_item(req);
	   
	   send_to_dut(req);
	   
	   seq_item_port.item_done();
	 end  
endtask

task ahb_driver::send_to_dut(ahb_xtn xtnh);
 vif.ahb_drv_cb.Haddr<=xtnh.Haddr;
 vif.ahb_drv_cb.Hburst<=xtnh.Hburst;
 vif.ahb_drv_cb.Htrans<=xtnh.Htrans;
 vif.ahb_drv_cb.Hsize<=xtnh.Hsize;
 vif.ahb_drv_cb.Hwrite<=xtnh.Hwrite;
 vif.ahb_drv_cb.Hreadyin<=1'b1;
@(vif.ahb_drv_cb);

wait(vif.ahb_drv_cb.Hreadyout);
vif.ahb_drv_cb.Hreadyin<=1'b0;
if(req.Hwrite)
  vif.ahb_drv_cb.Hwdata<=xtnh.Hwdata;
  
else
  vif.ahb_drv_cb.Hwdata<='dz;

`uvm_info(get_type_name,$sformatf(" printing from ahb driver \n %s ",xtnh.sprint()),UVM_MEDIUM);  
endtask

