`timescale 1ps/1ps

module control (
	input logic [10:0] Opcodes,
	output logic Reg2Loc, UncondBranch, Branch, AluSrc, RWrite, FWrite, MWrite, MRead, BL, BRsel, CBZBr, LTBr,
	output logic ImmSrc,
	output logic [1:0] Mem2Reg,
	output logic [2:0] AOp);

	always_comb begin
	//Defualt Case
	Reg2Loc = 0;
	UncondBranch = 0;
	Branch = 0;
	AluSrc = 0;
	RWrite = 0;
	FWrite = 0;
	MWrite = 0;
	MRead = 0;
	BL = 0;
	BRsel = 0;
	CBZBr = 0;
	LTBr = 0;
	ImmSrc = 0;
	Mem2Reg = 2'b00;
	AOp = 3'b010;
	
	
	casez (Opcodes)
	
	//ADDS (Adding and set flags)
	11'b10101011000: begin
		Reg2Loc = 1;
		RWrite = 1;
		FWrite = 1;
		AOp = 3'b010;
	end
	
	//ADDI (Adding Immediate)
	11'b1001000100?: begin
		AluSrc = 1;
		RWrite = 1;
		ImmSrc = 1;
		AOp = 3'b010;
	end
	
	//SUBS (Subtratc and Set Flags)
	11'b11101011000: begin
		Reg2Loc = 1;
		RWrite = 1;
		FWrite = 1;
		AOp = 3'b011;
	end
	
	//LDUR (Load)
	11'b11111000010: begin
		AluSrc = 1;
		RWrite = 1;
		MRead = 1;
		Mem2Reg = 2'b01;
		AOp = 3'b010;
	end
	
	//StUR (Store)
	11'b11111000000: begin
		AluSrc = 1;
		MWrite = 1;
		AOp = 3'b010;
	end
	
	//B (Branch Uncondiional)
	11'b000101?????: begin
		UncondBranch = 1;
	end
	
	//BL (Branch and Link)
	11'b100101?????: begin
		UncondBranch = 1;
		RWrite = 1;
		BL = 1;
		Mem2Reg = 2'b10;
	end
	
	//BR (Branch and Register)
	11'b11010110000: begin
	BRsel = 1;
	end
	
	//CBZ (Conditional Brnach Zero)
	11'b10110100???: begin
	CBZBr = 1;
	AOp = 3'b000;
	end
	
	//B.LT (Branch Less than)
	11'b01010100???: begin
	LTBr = 1;
	end
	default:;
endcase
end
endmodule

// This is our module that does our downstream classification for our operations. This allows tagging for our buffers, and reservation stations
module classification ( 
	input logic CBZBr, LTBr, UncondBranch, BL,  MRead, MWrite, valid,
	output logic toBranchRS, toLoadBuf, toStoreBuf, toAluRS);

	// BR is out of scope for module 1, due to BRSel not being checked here, so a BR would fall through to the toAluRS
	
	
	always_comb begin
		//Default Cases; basicall
		toBranchRS = 0;
		toLoadBuf = 0;
		toStoreBuf = 0;
		toAluRS = 0;

	if (valid) begin


		if(CBZBr || LTBr || UncondBranch || BL  ) // branch conditional classification
		toBranchRS = 1;

		else if (MRead)  // load conditional classification
		toLoadBuf = 1;

		else if (MWrite) // store conditional classification
		toStoreBuf = 1;

	else 
	// fall through to ALU classification

	toAluRS = 1;
	end
	
	

	end

// TODO(Lab1): testbench — verify one-hot output for BL, B.LT, load,
// store, ALU, and valid=0 idle case. See recognition-vs-reconstruction.


endmodule
	
		
	
	
	
		
	
	