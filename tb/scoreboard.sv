class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
   uvm_tlm_analysis_fifo #(apb_xtn) fifo_apb;
   uvm_tlm_analysis_fifo #(ahb_xtn) fifo_ahb;  

   ahb_xtn Hxtn1,Hxtn2,q[$];
   apb_xtn Pxtn,Pxtn1,pq[$];
   
   ahb_xtn ahb_cov;
   
   covergroup cg;
   option.per_instance=1;
   
   C1:coverpoint ahb_cov.Hwrite{
      bins read = {0};
	  bins write= {1};}
   
   C2:coverpoint ahb_cov.Haddr{
      bins S1 = {[32'h 8000_0000:32'h 8000_03ff]};
	  bins S2 = {[32'h 8400_0000:32'h 8400_03ff]};
	  bins S3 = {[32'h 8800_0000:32'h 8800_03ff]};
	  bins S4 = {[32'h 8c00_0000:32'h 8c00_03ff]};}
   
   C3:coverpoint ahb_cov.Hwdata{   
      option.auto_bin_max=8; }
	  
   C4:coverpoint ahb_cov.Hrdata{
      option.auto_bin_max=1; }
 //  coverpoint ahb_cov.Hrdata{
 //     option.auto_bin_max=8; }
	  
   C5:coverpoint ahb_cov.Hsize{
      bins B1 = {0};
	  bins B2 = {1};
      bins B3 = {2};} 
   
   C6:cross C1,C2,C5;
   endgroup  
   
   
  extern function new(string name="scoreboard",uvm_component parent);
  extern task run_phase(uvm_phase phase);
  extern task check_data();
  extern task compare(int HDATA,PDATA,HADDR,PADDR);
 
endclass

function scoreboard::new(string name="scoreboard",uvm_component parent);
  super.new(name,parent);
  fifo_ahb=new("fifo_ahb",this);
  fifo_apb=new("fifo_apb",this);
  cg=new;
endfunction

task scoreboard::run_phase(uvm_phase phase);
 super.run_phase(phase);
 
 Hxtn2=ahb_xtn::type_id::create("Hxtn2");
 
 Pxtn=apb_xtn::type_id::create("Pxtn");
 
 fork
  forever
    begin
	 fifo_ahb.get(Hxtn1);
	 q.push_back(Hxtn1);
	 `uvm_info(get_type_name,$sformatf("printing from scoreboard \n %s",Hxtn1.sprint),UVM_MEDIUM); 
     if(Hxtn1.Hwrite==0)	 
	   check_data();
	end
  
  forever
    begin
	 fifo_apb.get(Pxtn);
	`uvm_info(get_type_name,$sformatf("printing from scoreboard \n %s",Pxtn.sprint),UVM_MEDIUM);

	if(Pxtn.Pwrite) 
	 check_data();

	end
 join_none

endtask

task scoreboard::check_data();

 begin
 Hxtn2=q.pop_front;
 
 ahb_cov=Hxtn2;
 
 if(Hxtn2.Hwrite==0)
    begin  
      case(Hxtn2.Hsize)
	   3'b 000 :begin
		         if(Hxtn2.Haddr[1:0]==2'b00)
				   compare(Hxtn2.Hrdata[7:0],Pxtn.Prdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
		         if(Hxtn2.Haddr[1:0]==2'b01)
				   compare(Hxtn2.Hrdata[7:0],Pxtn.Prdata[15:8],Hxtn2.Haddr,Pxtn.Paddr);
		         if(Hxtn2.Haddr[1:0]==2'b10)
				   compare(Hxtn2.Hrdata[7:0],Pxtn.Prdata[23:16],Hxtn2.Haddr,Pxtn.Paddr);
		         if(Hxtn2.Haddr[1:0]==2'b11)
				   compare(Hxtn2.Hrdata[7:0],Pxtn.Prdata[31:24],Hxtn2.Haddr,Pxtn.Paddr);
		        end
	 
	   3'b 001 :begin
		         if(Hxtn2.Haddr[1:0]==2'b00)
				   compare(Hxtn2.Hrdata[15:0],Pxtn.Prdata[15:0],Hxtn2.Haddr,Pxtn.Paddr);
				 if(Hxtn2.Haddr[1:0]==2'b10)
				   compare(Hxtn2.Hrdata[15:0],Pxtn.Prdata[31:16],Hxtn2.Haddr,Pxtn.Paddr);
		        end
				
	   3'b 010 :begin
		         if(Hxtn2.Haddr[1:0]==2'b00)
				   compare(Hxtn2.Hrdata[31:0],Pxtn.Prdata[31:0],Hxtn2.Haddr,Pxtn.Paddr);
		        end
	 endcase
 
    end
else if(Hxtn2.Hwrite==1'b1)
    begin  
      case(Hxtn2.Hsize)
	    3'b 000 :begin
		         if(Hxtn2.Haddr[1:0]==2'b00)
				   compare(Hxtn2.Hwdata[7:0],Pxtn.Pwdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
		         if(Hxtn2.Haddr[1:0]==2'b01)
				   compare(Hxtn2.Hwdata[15:8],Pxtn.Pwdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
		         if(Hxtn2.Haddr[1:0]==2'b10)
				   compare(Hxtn2.Hwdata[23:16],Pxtn.Pwdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
		         if(Hxtn2.Haddr[1:0]==2'b11)
				   compare(Hxtn2.Hwdata[31:24],Pxtn.Pwdata[7:0],Hxtn2.Haddr,Pxtn.Paddr);
		        end
	 
	    3'b 001 :begin
		         if(Hxtn2.Haddr[1:0]==2'b00)
				   compare(Hxtn2.Hwdata[15:0],Pxtn.Pwdata[15:0],Hxtn2.Haddr,Pxtn.Paddr);
				 if(Hxtn2.Haddr[1:0]==2'b10)
				   compare(Hxtn2.Hwdata[31:16],Pxtn.Pwdata[15:0],Hxtn2.Haddr,Pxtn.Paddr);
		        end
				
		3'b 010 :begin
		         if(Hxtn2.Haddr[1:0]==2'b00)
				   compare(Hxtn2.Hwdata[31:0],Pxtn.Pwdata[31:0],Hxtn2.Haddr,Pxtn.Paddr);
		        end
			
	 endcase
    end 
end
endtask

task scoreboard::compare(int HDATA,PDATA,HADDR,PADDR);
if((HDATA!=0)&&(PDATA!=0))
 begin
  if(HDATA==PDATA)
   begin
   `uvm_info(get_type_name,$sformatf("Data compare successful HDATA=%0h and PDATA=%0h \n",HDATA,PDATA),UVM_LOW)
    cg.sample();
   end
  else
     begin
     `uvm_info(get_type_name,$sformatf("Data compare failed HDATA=%0h and PDATA=%0h \n",HDATA,PDATA),UVM_LOW)
     $finish;
    end
  if(HADDR==PADDR)
    `uvm_info(get_type_name,$sformatf("Addr compare successful HADDR=%0h and PADDR=%0h \n",HADDR,PADDR),UVM_LOW)
  else
     begin
     `uvm_info(get_type_name,$sformatf("Addr compare failed HADDR=%0h and PADDR=%0h \n",HADDR,PADDR),UVM_LOW)
     $finish;
    end
 end
endtask
