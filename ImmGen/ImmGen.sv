module ImmGen(
    input  logic [24:0] InmediateBits,
    input  logic [2:0]  ImmSrc,
    output logic [31:0] ImmExt
);
    localparam I_TYPE = 3'b000,
               S_TYPE = 3'b001,
               B_TYPE = 3'b101,
               U_TYPE = 3'b010,
               J_TYPE = 3'b011;

    always @* begin
        case (ImmSrc)
            I_TYPE: ImmExt = {{20{InmediateBits[24]}}, InmediateBits[24:13]}; // I-type
            S_TYPE: ImmExt = {{20{InmediateBits[24]}}, InmediateBits[24:18], InmediateBits[4:0]}; // S-type
            B_TYPE: ImmExt = {{19{InmediateBits[24]}}, InmediateBits[24], InmediateBits[0],
                              InmediateBits[23:18], InmediateBits[4:1], 1'b0}; // B-type
            U_TYPE: ImmExt = {InmediateBits[24:5], 12'b0}; // U-type
            J_TYPE: ImmExt = {{11{InmediateBits[24]}}, InmediateBits[24], InmediateBits[12:5],
                              InmediateBits[13], InmediateBits[23:14], 1'b0}; // J-type
            default: ImmExt = 32'b0;
        endcase
    end
endmodule
