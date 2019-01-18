// To be improved later on
module stall_control(
		     // Memory stage
		     input wire  d_cache_miss,
		     input wire  enable_write_from_cache_to_memory,

		     // Fetch stage
		     input wire  instruction_not_ready,

		     input 	 exec_flushPrevInstr,
		     input 	 decode_detectHazard_flush_CtrlBits,

		     output wire stall_at_wb,
		     output wire bubble_at_wb,
		     output wire stall_at_memory,
		     output wire bubble_at_memory,
		     output wire stall_at_exec,
		     output wire bubble_at_exec,
		     output wire stall_at_decode,
		     output wire bubble_at_decode,
		     output wire stall_at_fetch,
		     output wire bubble_at_fetch
		     );
   wire 			 branch_not_taken = exec_flushPrevInstr;

always@(*) begin
   $display("Branch_n_t %x, instr_not_ready %x", branch_not_taken, instruction_not_ready);
   end
   
   assign 			 stall_at_wb = 0;
   assign 			 stall_at_memory = (stall_at_wb || d_cache_miss || enable_write_from_cache_to_memory);
   assign 			 stall_at_exec = (stall_at_memory); // TODO : Should implement it in case the result (mul) was not ready
   assign 			 stall_at_decode = (stall_at_exec || decode_detectHazard_flush_CtrlBits); // TODO : Should implement bypasses though
   assign 			 stall_at_fetch = instruction_not_ready; // Update : I think I solved the fllowing problem by adding a RHS delay (artificial) intead of LHS delay // TODO : what about a cache_miss that corresponded to a non-taken pc ? 
   
   assign                        bubble_at_wb = mem_wb.exception || stall_at_memory;
   assign 			 bubble_at_memory = mem_wb.exception || branch_not_taken || (stall_at_exec && !stall_at_memory);
   assign 			 bubble_at_exec = branch_not_taken ||id_ex.iret || mem_wb.exception || branch_not_taken || (stall_at_decode && !stall_at_exec);
   assign 			 bubble_at_decode = branch_not_taken || id_ex.iret || mem_wb.exception || branch_not_taken || (stall_at_fetch && !stall_at_decode);
   assign 			 bubble_at_fetch = 0;
   
endmodule
