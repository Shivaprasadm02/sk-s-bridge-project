class ahb_agent extends uvm_agent;
 `uvm_component_utils(ahb_agent)
 ahb_driver drv;
 ahb_monitor mon;
 ahb_sequencer seqr;
 ahb_agt_config ahb_cfg;
 
 extern function new(string name="ahb_agent",uvm_component parent);
 extern function void build_phase(uvm_phase phase);
 extern function void connect_phase(uvm_phase phase);
endclass

function ahb_agent::new(string name="ahb_agent",uvm_component parent);
 super.new(name,parent);
endfunction

function void ahb_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",ahb_cfg))
    `uvm_fatal(get_full_name,"ne valla kadu vadiley////");
  
  mon=ahb_monitor::type_id::create("mon",this);  
  if(ahb_cfg.is_active==UVM_ACTIVE)
   begin
    drv=ahb_driver::type_id::create("drv",this); 
    seqr=ahb_sequencer::type_id::create("seqr",this); 
   end
endfunction

function void ahb_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if(ahb_cfg.is_active==UVM_ACTIVE)
    drv.seq_item_port.connect(seqr.seq_item_export);

endfunction