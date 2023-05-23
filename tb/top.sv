module top;

import bridge_pkg::*;

import uvm_pkg::*;

bit clk;
always #5 clk=~clk;

bridge_if vif(clk); 

rtl_top DUT(.Hclk(clk),
            .Hresetn(vif.Hresetn),
            .Haddr(vif.Haddr),
			.Hreadyin(vif.Hreadyin),
			.Hreadyout(vif.Hreadyout),
			.Hresp(vif.Hresp),
			.Hsize(vif.Hsize),
			.Htrans(vif.Htrans),
			.Hwdata(vif.Hwdata),
			.Hwrite(vif.Hwrite),
			.Hrdata(vif.Hrdata),
			.Paddr(vif.Paddr),
			.Penable(vif.Penable),
			.Prdata(vif.Prdata),
			.Pselx(vif.Pselx),
			.Pwdata(vif.Pwdata),
			.Pwrite(vif.Pwrite)); 
                                  
initial
  begin
    
	uvm_config_db #(virtual bridge_if)::set(null,"*","vif",vif);
	
		
    run_test("bridge_test");
  end

endmodule
