class ahb_agent_top extends uvm_env;

	`uvm_component_utils(ahb_agent_top)

	ahb_agent ahb_agt[];
	env_config m_cfg;
    
	
	extern function new(string name="ahb_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
	
endclass

	
function ahb_agent_top :: new(string name="ahb_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void ahb_agent_top :: build_phase(uvm_phase phase);
	super.build_phase(phase);

    if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	  `uvm_fatal(get_full_name,"error vundi chusukooo////");
  
    ahb_agt=new[m_cfg.no_of_Hagent];
	foreach(ahb_agt[i])
	 ahb_agt[i]=ahb_agent::type_id::create($sformatf("ahb_agt[%0d]",i),this);

endfunction






