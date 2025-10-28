module NextPC(
    input logic [1:0]   RUDataWrSrc,
    input logic [31:0]  PC_with_offset,
    input logic [31:0]  DataRd,
    input logic [31:0]  ALURes,
    output logic [31:0] DataWr
);

    localparam  PC_WITH_OFFSET = 2'b10,
                DATARD    = 2'b01,
                ALURES  = 2'b00;

always @* begin
    case (RUDataWrSrc)
        PC_WITH_OFFSET: DataWr = PC_with_offset; // jal, jalr
        DATARD:     DataWr = DataRd;         // For Load instructions
        ALURES:   DataWr = ALURes;        // For ALU operations
        default:  DataWr = 32'd0;
    endcase
end
endmodule


    