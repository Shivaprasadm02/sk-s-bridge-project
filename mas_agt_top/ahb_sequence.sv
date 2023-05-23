class ahb_sequence extends uvm_sequence #(ahb_xtn);

`uvm_object_utils(ahb_sequence)

//-----Local Variables------------
bit [31:0] haddr;
bit [2:0] hsize, hburst;
bit hwrite;
bit [9:0] len;

extern function new (string name = "ahb_sequence");

endclass

function ahb_sequence :: new (string name = "ahb_sequence");
super.new(name);
endfunction



//-------------WRITE SEQUENCE------------

class ahb_write_sequence extends ahb_sequence;
`uvm_object_utils(ahb_write_sequence)

extern function new (string name = "ahb_write_sequence");
extern task body();
endclass

function ahb_write_sequence :: new (string name = "ahb_write_sequence");
super.new(name);
endfunction

task ahb_write_sequence :: body();
repeat(100)
begin
req = ahb_xtn :: type_id ::create("ahb_xtn");
start_item(req);
assert(req.randomize() with {Htrans == 2'b10;Hwrite == 1;});
finish_item(req);

haddr = req.Haddr;
hsize = req.Hsize;
hwrite = req.Hwrite;
hburst = req.Hburst;

//-----------INCREMENT SEQ TRANSFERS---------------
/*-----------bit for Addr----------------------
Hsize == 0 -------===>> add 1 to addr
Hsize == 1 -------===>> add 2 to addr
Hsize == 2 -------===>> add 4 to addr
--------------------------------------------------------
*/
if(hburst == 3'b001 || hburst == 3'b011 || hburst == 3'b101 || hburst == 3'b111)
 begin
if(hburst == 3'b001)//--------==>>INCR
len = req.length;

if(hburst == 3'b011)//--------==>>INCR4
len = 3;

if(hburst == 3'b101)//--------==>>INCR8
len = 7;

if(hburst == 3'b111)//--------==>>INCR16
len = 15;

for(int i=0;i<len;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 1'b1;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 2'd2;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 3'd4;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
//-----------WRAP SEQ TRANSFERS---------------------------------------------------------------
/*-----------bit for Addr-----------------------------
WRAP4  ----> to 2 bits + 1'b1 
WRAP8  ----> to 3 bits + 1'b1 
WRAP16 ----> to 4 bits + 1'b1   -------->>> if Hsize ===> 0 --> start from 0th  bit
                                                          1 --> start from 1th  bit
														  2 --> start from 2th  bit
---------------------------------------------------------------------------------------------                              
*/
if(hburst == 3'b010)//---->>>WRAP4
begin
 
for(int i=0;i<3;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:2],haddr[1:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:3],haddr[2:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
 //------------WRAP8-----------------
 
if(hburst == 3'b100)
begin
 
for(int i=0;i<7;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:3],haddr[2:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:5],haddr[4:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
 
 //------------WRAP16-----------------
 
if(hburst == 3'b110)
begin
 
for(int i=0;i<7;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:5],haddr[4:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:6],haddr[5:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
/*start_item(req);
assert(req.randomize() with {Htrans == 2'b00;Hburst == hburst;Hwrite == hwrite;Hsize == hsize;});
finish_item(req);*/
end 

endtask


//-------------------------               READ SEQUENCE Hsize 1              -----------------------------------------------------------
class ahb_read_sequence extends ahb_sequence;
`uvm_object_utils(ahb_read_sequence)

extern function new (string name = "ahb_read_sequence");
extern task body();
endclass

function ahb_read_sequence :: new (string name = "ahb_read_sequence");
super.new(name);
endfunction


task ahb_read_sequence :: body();
repeat(20)
begin
req = ahb_xtn :: type_id ::create("ahb_xtn");
start_item(req);
assert(req.randomize() with {Htrans == 2'b10;Hsize == 1;Hwrite == 1'b0;});
finish_item(req);

haddr = req.Haddr;
hsize = req.Hsize;
hwrite = req.Hwrite;
hburst = req.Hburst;

//-----------INCREMENT SEQ TRANSFERS---------------
/*-----------bit for Addr----------------------
Hsize == 0 -------===>> add 1 to addr
Hsize == 1 -------===>> add 2 to addr
Hsize == 2 -------===>> add 4 to addr
--------------------------------------------------------*/

if(hburst == 3'b001 || hburst == 3'b011 || hburst == 3'b101 || hburst == 3'b111)
 begin
if(hburst == 3'b001)//--------==>>INCR
len = req.length;

if(hburst == 3'b011)//--------==>>INCR4
len = 3;

if(hburst == 3'b101)//--------==>>INCR8
len = 7;

if(hburst == 3'b111)//--------==>>INCR16
len = 15;

for(int i=0;i<len;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 1'b1;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 2'd2;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 3'd4;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
//-----------WRAP SEQ TRANSFERS---------------------------------------------------------------
/*-----------bit for Addr-----------------------------
WRAP4  ----> to 2 bits + 1'b1 
WRAP8  ----> to 3 bits + 1'b1 
WRAP16 ----> to 4 bits + 1'b1   -------->>> if Hsize ===> 0 --> start from 0th  bit
                                                          1 --> start from 1th  bit
														  2 --> start from 2th  bit
--------------------------------------------------------------------------------------------- */                             

if(hburst == 3'b010)//---->>>WRAP4
begin
 
for(int i=0;i<3;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:2],haddr[1:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:3],haddr[2:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
 //------------WRAP8-----------------
 
if(hburst == 3'b100)
begin
 
for(int i=0;i<7;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:3],haddr[2:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:5],haddr[4:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
 
 //------------WRAP16-----------------
 
if(hburst == 3'b110)
begin
 
for(int i=0;i<7;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:5],haddr[4:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:6],haddr[5:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
end 
endtask




//-------------------------               READ SEQUENCE 0             -----------------------------------------------------------
class ahb_read_sequence1 extends ahb_sequence;
`uvm_object_utils(ahb_read_sequence1)

extern function new (string name = "ahb_read_sequence1");
extern task body();
endclass

function ahb_read_sequence1 :: new (string name = "ahb_read_sequence1");
super.new(name);
endfunction


task ahb_read_sequence1 :: body();
repeat(20)
begin
req = ahb_xtn :: type_id ::create("ahb_xtn");
start_item(req);
assert(req.randomize() with {Htrans == 2'b10;Hsize == 0;Hwrite == 1'b0;});
finish_item(req);

haddr = req.Haddr;
hsize = req.Hsize;
hwrite = req.Hwrite;
hburst = req.Hburst;

//-----------INCREMENT SEQ TRANSFERS---------------
/*-----------bit for Addr----------------------
Hsize == 0 -------===>> add 1 to addr
Hsize == 1 -------===>> add 2 to addr
Hsize == 2 -------===>> add 4 to addr
--------------------------------------------------------*/

if(hburst == 3'b001 || hburst == 3'b011 || hburst == 3'b101 || hburst == 3'b111)
 begin
if(hburst == 3'b001)//--------==>>INCR
len = req.length;

if(hburst == 3'b011)//--------==>>INCR4
len = 3;

if(hburst == 3'b101)//--------==>>INCR8
len = 7;

if(hburst == 3'b111)//--------==>>INCR16
len = 15;

for(int i=0;i<len;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 1'b1;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 2'd2;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 3'd4;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
//-----------WRAP SEQ TRANSFERS---------------------------------------------------------------
/*-----------bit for Addr-----------------------------
WRAP4  ----> to 2 bits + 1'b1 
WRAP8  ----> to 3 bits + 1'b1 
WRAP16 ----> to 4 bits + 1'b1   -------->>> if Hsize ===> 0 --> start from 0th  bit
                                                          1 --> start from 1th  bit
														  2 --> start from 2th  bit
--------------------------------------------------------------------------------------------- */                             

if(hburst == 3'b010)//---->>>WRAP4
begin
 
for(int i=0;i<3;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:2],haddr[1:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:3],haddr[2:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
 //------------WRAP8-----------------
 
if(hburst == 3'b100)
begin
 
for(int i=0;i<7;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:3],haddr[2:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:5],haddr[4:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
 
 //------------WRAP16-----------------
 
if(hburst == 3'b110)
begin
 
for(int i=0;i<7;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:5],haddr[4:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:6],haddr[5:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
end 
endtask




//-------------------------               READ SEQUENCE 2             -----------------------------------------------------------
class ahb_read_sequence2 extends ahb_sequence;
`uvm_object_utils(ahb_read_sequence2)

extern function new (string name = "ahb_read_sequence2");
extern task body();
endclass

function ahb_read_sequence2 :: new (string name = "ahb_read_sequence2");
super.new(name);
endfunction


task ahb_read_sequence2 :: body();
repeat(20)
begin
req = ahb_xtn :: type_id ::create("ahb_xtn");
start_item(req);
assert(req.randomize() with {Htrans == 2'b10;Hsize == 2;Hwrite == 1'b0;});
finish_item(req);

haddr = req.Haddr;
hsize = req.Hsize;
hwrite = req.Hwrite;
hburst = req.Hburst;

//-----------INCREMENT SEQ TRANSFERS---------------
/*-----------bit for Addr----------------------
Hsize == 0 -------===>> add 1 to addr
Hsize == 1 -------===>> add 2 to addr
Hsize == 2 -------===>> add 4 to addr
--------------------------------------------------------*/

if(hburst == 3'b001 || hburst == 3'b011 || hburst == 3'b101 || hburst == 3'b111)
 begin
if(hburst == 3'b001)//--------==>>INCR
len = req.length;

if(hburst == 3'b011)//--------==>>INCR4
len = 3;

if(hburst == 3'b101)//--------==>>INCR8
len = 7;

if(hburst == 3'b111)//--------==>>INCR16
len = 15;

for(int i=0;i<len;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 1'b1;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 2'd2;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == haddr + 3'd4;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
//-----------WRAP SEQ TRANSFERS---------------------------------------------------------------
/*-----------bit for Addr-----------------------------
WRAP4  ----> to 2 bits + 1'b1 
WRAP8  ----> to 3 bits + 1'b1 
WRAP16 ----> to 4 bits + 1'b1   -------->>> if Hsize ===> 0 --> start from 0th  bit
                                                          1 --> start from 1th  bit
														  2 --> start from 2th  bit
--------------------------------------------------------------------------------------------- */                             

if(hburst == 3'b010)//---->>>WRAP4
begin
 
for(int i=0;i<3;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:2],haddr[1:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:3],haddr[2:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
 //------------WRAP8-----------------
 
if(hburst == 3'b100)
begin
 
for(int i=0;i<7;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:3],haddr[2:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:5],haddr[4:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
 
 //------------WRAP16-----------------
 
if(hburst == 3'b110)
begin
 
for(int i=0;i<7;i++)
begin
start_item(req);

if(hsize == 0)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:4],haddr[3:0]+1'b1} ;} );

if(hsize == 1)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:5],haddr[4:1]+1'b1,haddr[0]} ;} );

if(hsize == 2)
assert(req.randomize() with {Hsize == hsize;
                             Hburst == hburst;
							 Hwrite == hwrite;
							 Htrans == 2'b11;
							 Haddr == {haddr[31:6],haddr[5:2]+1'b1,haddr[1:0]} ;} );	

finish_item(req);

haddr = req.Haddr;
end							 
 end
 
end 
endtask
