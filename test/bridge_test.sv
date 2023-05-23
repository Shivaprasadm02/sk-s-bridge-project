class bridge_test extends uvm_test;
`uvm_component_utils(bridge_test)

//------local configuration handles
env_config m_cfg;
ahb_agt_config ahb_cfg[];
apb_agt_config apb_cfg[];

environment envh;


bit has_Hagent = 1;
bit has_Pagent = 1;
bit has_virtual_sequencer = 1;
bit has_scoreboard = 1;
int no_of_Hagent = 1;
int no_of_Pagent = 1;


extern function new (string name = "bridge_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void bridge_config();

endclass

function bridge_test :: new (string name = "bridge_test",uvm_component parent);
super.new(name,parent);
endfunction


function void bridge_test :: bridge_config();
if(has_Hagent)
begin
ahb_cfg = new[no_of_Hagent];

foreach(ahb_cfg[i])
begin
ahb_cfg[i] = ahb_agt_config::type_id::create($sformatf("ahb_cfg[%0d]",i));

if(!uvm_config_db #(virtual bridge_if) :: get(this,"","vif",ahb_cfg[i].vif))
`uvm_fatal(get_type_name,"Unable to GET");

ahb_cfg[i].is_active = UVM_ACTIVE;
m_cfg.ahb_cfg[i] = ahb_cfg[i];
end
end

if(has_Pagent)
begin
apb_cfg = new[no_of_Pagent];

foreach(apb_cfg[i])
begin
apb_cfg[i] = apb_agt_config::type_id::create($sformatf("apb_cfg[%0d]",i));

if(!uvm_config_db #(virtual bridge_if) :: get(this,"","vif",apb_cfg[i].vif))
`uvm_fatal(get_type_name,"Unable to GET");

apb_cfg[i].is_active = UVM_ACTIVE;
m_cfg.apb_cfg[i] = apb_cfg[i];
end
end

m_cfg.no_of_Hagent = no_of_Hagent;
m_cfg.no_of_Pagent = no_of_Pagent;
m_cfg.has_Hagent = has_Hagent;
m_cfg.has_Pagent = has_Pagent;

endfunction

function void bridge_test :: build_phase(uvm_phase phase);
m_cfg = env_config :: type_id :: create("m_cfg");
if(has_Hagent)
m_cfg.ahb_cfg = new[no_of_Hagent];
if(has_Pagent)
m_cfg.apb_cfg = new[no_of_Pagent];

bridge_config();

uvm_config_db #(env_config) :: set(this,"*","env_config",m_cfg);
super.build_phase(phase);
envh=environment::type_id::create("envh",this);

endfunction


////////////////------------------------------------------------------------
class wr_test extends bridge_test;

`uvm_component_utils(wr_test)
virtual_sequence1 vseq1;

extern function new (string name = "wr_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function wr_test :: new (string name = "wr_test",uvm_component parent);
super.new(name,parent);
endfunction

function void wr_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task wr_test :: run_phase(uvm_phase phase);
phase.raise_objection(this);
vseq1 = virtual_sequence1 ::type_id::create("vseq1");
vseq1.start(envh.vseqr);
#50;
phase.drop_objection(this);
endtask

////////////////------------------------------------------------------------
class rd_test extends bridge_test;

`uvm_component_utils(rd_test)

virtual_sequence2 vseq2;
extern function new (string name = "rd_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function rd_test :: new (string name = "rd_test",uvm_component parent);
super.new(name,parent);
endfunction

function void rd_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task rd_test :: run_phase(uvm_phase phase);
phase.raise_objection(this);

vseq2 = virtual_sequence2 ::type_id::create("vseq2");

vseq2.start(envh.vseqr);
#50;
phase.drop_objection(this);
endtask



////////////////------------------------------------------------------------
class rd_test1 extends bridge_test;

`uvm_component_utils(rd_test1)

virtual_sequencer3 vseq3;
extern function new (string name = "rd_test1",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function rd_test1 :: new (string name = "rd_test1",uvm_component parent);
super.new(name,parent);
endfunction

function void rd_test1::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task rd_test1 :: run_phase(uvm_phase phase);
phase.raise_objection(this);

vseq3 = virtual_sequencer3 ::type_id::create("vseq3");

vseq3.start(envh.vseqr);
#50;
phase.drop_objection(this);
endtask





////////////////------------------------------------------------------------
class rd_test2 extends bridge_test;

`uvm_component_utils(rd_test2)

virtual_sequence4 vseq4;
extern function new (string name = "rd_test2",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function rd_test2 :: new (string name = "rd_test2",uvm_component parent);
super.new(name,parent);
endfunction

function void rd_test2::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task rd_test2 :: run_phase(uvm_phase phase);
phase.raise_objection(this);

vseq4 = virtual_sequence4 ::type_id::create("vseq4");

vseq4.start(envh.vseqr);
#50;
phase.drop_objection(this);
endtask


