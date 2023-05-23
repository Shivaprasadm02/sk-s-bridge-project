class ahb_monitor extends uvm_monitor;
`uvm_component_utils(ahb_monitor)

ahb_agt_config ahb_cfg;
virtual bridge_if.AHB_MON_MP vif;
ahb_xtn xtnh,xtnh1;

uvm_analysis_port#(ahb_xtn) monitor_port;


extern function new(string name="ahb_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();

endclass

function ahb_monitor::new(string name="ahb_monitor",uvm_component parent);
super.new(name,parent);
monitor_port=new("monitor_port",this);
endfunction

function void ahb_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",ahb_cfg))
  `uvm_fatal(get_full_name,"inka waste ne valla kadu//");

xtnh=ahb_xtn::type_id::create("xtnh");
endfunction

function void ahb_monitor::connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 vif=ahb_cfg.vif;
endfunction


task ahb_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
 
  wait(vif.ahb_mon_cb.Hreadyout && vif.ahb_mon_cb.Htrans==2'b10);
 
  forever
   collect_data();

endtask

task ahb_monitor::collect_data();
 
 xtnh.Haddr = vif.ahb_mon_cb.Haddr;
 xtnh.Hburst = vif.ahb_mon_cb.Hburst;
 xtnh.Htrans = vif.ahb_mon_cb.Htrans;
 xtnh.Hsize = vif.ahb_mon_cb.Hsize;
 xtnh.Hwrite = vif.ahb_mon_cb.Hwrite;

 @(vif.ahb_mon_cb);
wait(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.Htrans==2'b10 ||vif.ahb_mon_cb.Htrans==2'b11));

 xtnh.Hwdata = vif.ahb_mon_cb.Hwdata;
 
 xtnh.Hrdata = vif.ahb_mon_cb.Hrdata;
 
 xtnh1=new xtnh;
 
 monitor_port.write(xtnh1);

`uvm_info(get_type_name,$sformatf("printing from ahb monitor \n %s",xtnh.sprint),UVM_MEDIUM); 

endtask