/********1*********2*********3*********4*********5*********6*********7*********8
*
* FILE      : sys_rst_fm.v
* FUNCTION  : reset signal of the system
* AUTHOR    :
*
*_______________________________________________________________________________
*
* REVISION HISTORY
*
* Name                 Date         Comments
* ------------------------------------------------------------------------------
* rcasanova         26/Feb/2013  Created
* ------------------------------------------------------------------------------
*_______________________________________________________________________________
* 
* FUNCTIONAL DESCRIPTION 
*
*_______________________________________________________________________________
* 
* (c) Copyright Universitat de Barcelona, 2013 
* All rights reserved. Copying or other reproduction of this 
* program except for archival purposes is prohibited.
*
*********1*********2*********3*********4*********5*********6*********7*********/

module sys_rst_fm (                  
    Rst_n                   
    );

output          Rst_n            ;   // Generated reset
reg             Rst_n            ; 

initial
 begin
   Rst_n = 1;
 end
 
// -----------------------------------------------------------------------------
// Task: sys.rstOn
// Asserts reset (Rst_n=0 & Rst=1)
// -----------------------------------------------------------------------------
task rstOn; begin
    Rst_n=1;
end
endtask // rstOn

// -----------------------------------------------------------------------------
// Task: sys.rstOff
// Deasserts reset (Rst_n=0 & Rst=1)
// -----------------------------------------------------------------------------
task rstOff; begin
    Rst_n=0;
end
endtask // rstOff

// 

endmodule