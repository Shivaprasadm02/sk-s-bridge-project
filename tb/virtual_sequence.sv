class virtual_sequence extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(virtual_sequence)

ahb_sequencer ahb_seqr[];
apb_sequencer apb_seqr[];
///---------------handle for virtual sequencer
virtual_sequencer vsqr;

env_config m_cfg;

extern function new(string name = "virtual_sequence");
extern task body();
endclass 

function virtual_sequence :: new(string name = "virtual_sequence");
super.new(name);
endfunction

task virtual_sequence :: body();

if(!uvm_config_db #(env_config) ::get(null,get_full_name(),"env_config",m_cfg))
`uvm_fatal("VBASE CONFIG","unable to GET");

 apb_seqr = new[m_cfg.no_of_Pagent];
 ahb_seqr = new[m_cfg.no_of_Hagent];
 
if(!($cast(vsqr,m_sequencer)))
 begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end
foreach(ahb_seqr[i])  
ahb_seqr[i] = vsqr .ahb_seqr[i];
foreach(apb_seqr[i])
apb_seqr[i] = vsqr .apb_seqr[i];

endtask

//-------------WRite virtualsequence--------------------
class virtual_sequence1 extends virtual_sequence;

`uvm_object_utils(virtual_sequence1)
ahb_write_sequence vwr_seq;

extern function new(string name = "virtual_sequence1");
extern task body();
endclass 

function virtual_sequence1::new(string name ="virtual_sequence1");
super.new(name);
endfunction

task virtual_sequence1 :: body();

super.body;

vwr_seq = ahb_write_sequence :: type_id :: create("vwr_seq");

 if(m_cfg.has_Hagent)
 begin
 for(int i=0;i<m_cfg.no_of_Hagent;i++)
 begin

 vwr_seq.start(ahb_seqr[i]);

  end
 end

endtask
 
 


 //-------------Read virtualsequence  1  --------------------
class virtual_sequence2 extends virtual_sequence;

`uvm_object_utils(virtual_sequence2)
ahb_read_sequence vrd_seq;
extern function new(string name = "virtual_sequence2");
extern task body();
endclass 

function virtual_sequence2::new(string name ="virtual_sequence2");
super.new(name);
endfunction

task virtual_sequence2 :: body();

super.body;

vrd_seq = ahb_read_sequence :: type_id :: create("vrd_seq");
 if(m_cfg.has_Hagent)
 begin
 for(int i=0;i<m_cfg.no_of_Hagent;i++)
 begin
 vrd_seq.start(ahb_seqr[i]);
  end
 end

endtask
 

  //-------------Read virtualsequence  0 --------------------
class virtual_sequencer3 extends virtual_sequence;

`uvm_object_utils(virtual_sequencer3)
ahb_read_sequence1 vrd_seq1;
extern function new(string name = "virtual_sequencer3");
extern task body();
endclass 

function virtual_sequencer3::new(string name ="virtual_sequencer3");
super.new(name);
endfunction

task virtual_sequencer3 :: body();

super.body;

vrd_seq1 = ahb_read_sequence1 :: type_id :: create("vrd_seq1");
 if(m_cfg.has_Hagent)
 begin
 for(int i=0;i<m_cfg.no_of_Hagent;i++)
 begin
 vrd_seq1.start(ahb_seqr[i]);
  end
 end

endtask


 //-------------Read virtualsequence  2 --------------------
class virtual_sequence4 extends virtual_sequence;

`uvm_object_utils(virtual_sequence4)
ahb_read_sequence2 vrd_seq2;
extern function new(string name = "virtual_sequence4");
extern task body();
endclass 

function virtual_sequence4::new(string name ="virtual_sequence4");
super.new(name);
endfunction

task virtual_sequence4 :: body();

super.body;

vrd_seq2 = ahb_read_sequence2 :: type_id :: create("vrd_seq2");
 if(m_cfg.has_Hagent)
 begin
 for(int i=0;i<m_cfg.no_of_Hagent;i++)
 begin
 vrd_seq2.start(ahb_seqr[i]);
  end
 end

endtask
 


