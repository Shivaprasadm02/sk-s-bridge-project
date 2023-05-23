class apb_xtn extends uvm_sequence_item;
 
 `uvm_object_utils(apb_xtn)
 
    logic  Penable;
	logic  Pwrite;
	logic [3:0]Pselx;
	logic [31:0]Pwdata;
	logic [31:0]Prdata;
	logic [31:0]Paddr; 
/* `uvm_object_utils_begin(apb_xtn)
  `uvm_field_int(Penable,UVM_ALL_ON)
  `uvm_field_int(Paddr,UVM_ALL_ON)
  `uvm_field_int(Prdata,UVM_ALL_ON)
  `uvm_field_int(Pselx,UVM_ALL_ON)
  `uvm_field_int(Pwdata,UVM_ALL_ON)
  `uvm_field_int(Pwrite,UVM_ALL_ON)
 `uvm_object_utils_end
 */

 
extern function new(string name="apb_xtn");
extern function void do_print(uvm_printer printer);

endclass

function apb_xtn::new(string name="apb_xtn");
  super.new(name);
endfunction


function void apb_xtn::do_print(uvm_printer printer);
super.do_print(printer);

$display("\n-------------------------------------------------------------");
printer.print_field("Penable",   this.Penable,   1,      UVM_DEC);
printer.print_field("Pselx",     this.Pselx,     4,      UVM_DEC);
printer.print_field("Pwrite",    this.Pwrite,    1,      UVM_DEC);
printer.print_field("Paddr",     this.Paddr ,    32,     UVM_HEX);
printer.print_field("Pwdata",    this.Pwdata,    32,     UVM_HEX);
printer.print_field("Prdata",    this.Prdata,    32,     UVM_HEX);
$display("-------------------------------------------------------------\n");

endfunction
