class apb_monitor extends uvm_monitor;
`uvm_component_utils(apb_monitor)

uvm_analysis_port#(apb_xtn) monitor_port;

apb_agt_config apb_cfg;
virtual bridge_if.APB_MON_MP vif;
apb_xtn xtnh;

extern function new(string name="apb_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();

endclass

function apb_monitor::new(string name="apb_monitor",uvm_component parent);
super.new(name,parent);
monitor_port=new("monitor_port",this);
endfunction

function void apb_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
  `uvm_fatal(get_full_name,"inka waste ne valla kadu//");

xtnh=apb_xtn::type_id::create("xtnh");
endfunction

function void apb_monitor::connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 vif=apb_cfg.vif;
endfunction

task apb_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
   forever
    collect_data();
endtask

task apb_monitor::collect_data();
 
 wait(vif.apb_mon_cb.Penable);
 
 xtnh.Paddr=vif.apb_mon_cb.Paddr;
 xtnh.Pselx=vif.apb_mon_cb.Pselx;
 xtnh.Penable=vif.apb_mon_cb.Penable;
 xtnh.Pwrite=vif.apb_mon_cb.Pwrite;
if(xtnh.Pwrite)
 begin
  xtnh.Pwdata=vif.apb_mon_cb.Pwdata;
  xtnh.Prdata=0;
 end
 
if(!xtnh.Pwrite)
 begin
  xtnh.Prdata=vif.apb_mon_cb.Prdata;
  xtnh.Pwdata=0;
 end
 `uvm_info(get_full_name,$sformatf("printing from apb monitor \n %s",xtnh.sprint),UVM_MEDIUM);
 
 monitor_port.write(xtnh);
 
 @(vif.apb_mon_cb);
endtask



