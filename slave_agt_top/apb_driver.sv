class apb_driver extends uvm_driver #(apb_xtn);
 `uvm_component_utils(apb_driver)
 
 virtual bridge_if.APB_DRV_MP vif;
 apb_agt_config apb_cfg;
 
 extern function new(string name="apb_driver",uvm_component parent);
 extern function void build_phase(uvm_phase phase);
 extern function void connect_phase(uvm_phase phase);
 extern task run_phase(uvm_phase phase);
 extern task send_to_dut();
endclass

function apb_driver::new(string name="apb_driver",uvm_component parent);
 super.new(name,parent);
endfunction

function void apb_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

 if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
   `uvm_fatal(get_full_name,"inka waste ne valla kadu//");
  
endfunction

function void apb_driver::connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 vif=apb_cfg.vif;
endfunction

task apb_driver::run_phase(uvm_phase phase);
 super.run_phase(phase);
 forever
 send_to_dut();
endtask

task apb_driver::send_to_dut();

wait(vif.apb_drv_cb.Pselx);
if(vif.apb_drv_cb.Pwrite==0)

vif.apb_drv_cb.Prdata<=$random;
`uvm_info("APB_DRIVER",$sformatf("printing from apb driver \n ----------------\n %h \n ----------------",vif.apb_drv_cb.Prdata),UVM_MEDIUM);
repeat(2)
@(vif.apb_drv_cb);
endtask


