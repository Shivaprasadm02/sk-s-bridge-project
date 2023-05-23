class environment extends uvm_env;
`uvm_component_utils(environment)

env_config m_cfg;
virtual_sequencer vseqr;
apb_agent_top Pagt_top;
ahb_agent_top Hagt_top;

scoreboard sb;

extern function new(string name="environment",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
 
endclass
 
function environment::new(string name="environment",uvm_component parent);
 
  super.new(name,parent);
 
endfunction
 
function void environment::build_phase(uvm_phase phase);
  super.build_phase(phase);
 
 if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
   `uvm_fatal(get_full_name,"error at get config////");
   
   if(m_cfg.has_Hagent)
    begin
     Hagt_top=ahb_agent_top::type_id::create("Hagt_top",this);
	 foreach(m_cfg.ahb_cfg[i])
	   uvm_config_db #(ahb_agt_config)::set(this,"*","ahb_agt_config",m_cfg.ahb_cfg[i]);
   	end
	 
   if(m_cfg.has_Pagent)
    begin   
     Pagt_top=apb_agent_top::type_id::create("Pagt_top",this);
	 foreach(m_cfg.apb_cfg[i])
	   uvm_config_db #(apb_agt_config)::set(this,"*","apb_agt_config",m_cfg.apb_cfg[i]);
    end
  
   if(m_cfg.has_virtual_sequencer)
     vseqr=virtual_sequencer::type_id::create("vseqr",this);
  
   if(m_cfg.has_scoreboard)
     sb=scoreboard::type_id::create("sb",this); 
 
endfunction
 
function void environment::connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 
 if(m_cfg.has_virtual_sequencer) 
  begin
     if(m_cfg.has_Hagent)
	   foreach(m_cfg.ahb_cfg[i])
          vseqr.ahb_seqr[i]=Hagt_top.ahb_agt[i].seqr;
     if(m_cfg.has_Pagent)
       foreach(m_cfg.apb_cfg[i])
          vseqr.apb_seqr[i]=Pagt_top.apb_agt[i].seqr;
  end 
 if(m_cfg.has_scoreboard) 
  begin
   if(m_cfg.has_Hagent)
    for(int i=0;i<m_cfg.no_of_Hagent;i++)
     Hagt_top.ahb_agt[i].mon.monitor_port.connect(sb.fifo_ahb.analysis_export);
   
   if(m_cfg.has_Pagent)
    for(int i=0;i<m_cfg.no_of_Pagent;i++) 
     Pagt_top.apb_agt[i].mon.monitor_port.connect(sb.fifo_apb.analysis_export);
    
  end
 
endfunction