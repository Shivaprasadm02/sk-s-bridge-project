class apb_agent_top extends uvm_env;

	`uvm_component_utils(apb_agent_top)

	env_config m_cfg;
	apb_agent apb_agt[];

	extern function new(string name="apb_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
	
endclass

	
function apb_agent_top :: new(string name="apb_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_agent_top :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	  `uvm_fatal(get_full_name,"error vundi chusukooo////");
	  
	 apb_agt=new[m_cfg.no_of_Pagent];
	 foreach(apb_agt[i])
	  apb_agt[i]=apb_agent::type_id::create($sformatf("apb_agt[%0d]",i),this);

endfunction
