class env_config extends uvm_object;
`uvm_object_utils(env_config)

bit has_virtual_sequencer=1;

bit has_Hagent=1;

bit has_Pagent=1;

bit has_scoreboard=1;

ahb_agt_config ahb_cfg[];
apb_agt_config apb_cfg[];

int no_of_Hagent=1;
int no_of_Pagent=4;

extern function new(string name="env_config");

endclass

function env_config::new(string name="env_config");
  
  super.new(name);

endfunction