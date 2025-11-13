module DataMemory(
    input logic [31:0] Address,
    input logic [31:0] DataWr,

    input logic DMWr,
    input logic [2:0] DMCtrl,

    output logic [31:0] DataRd
);

    localparam  LB   = 3'b000,
                LH   = 3'b001,
                LW   = 3'b010,
                LB_U = 3'b100,
                LH_U = 3'b101,
                SB   = 3'b000,
                SH   = 3'b001,
                SW   = 3'b010;

    // memory matrix
    logic [7:0] dm [0:8192]; // 8 KiB = 64 Kbits

    logic [7:0] byte0, byte1, byte2, byte3;

    assign byte0 = dm[Address];
    assign byte1 = dm[Address + 1];
    assign byte2 = dm[Address + 2];
    assign byte3 = dm[Address + 3];

    // read logic
    always @* begin
        case (DMCtrl)
            LB:      DataRd = {{24{byte0[7]}}, byte0};
            LB_U:    DataRd = {24'b0, byte0};
            LH:      DataRd = {{16{byte1[7]}}, byte1, byte0};
            LH_U:    DataRd = {16'b0, byte1, byte0};
            LW:      DataRd = {byte3, byte2, byte1, byte0};
            default: DataRd = 32'b0;
        endcase
    end

    // write logic
    always @(posedge DMWr) begin
        case (DMCtrl)
            SB: begin
                dm[Address] <= DataWr[7:0];
            end
            SH: begin
                dm[Address]   <= DataWr[7:0];
                dm[Address+1] <= DataWr[15:8];
            end
            SW: begin
                /* dm[Address]   <= DataWr[7:0];
                dm[Address+1] <= DataWr[15:8];
                dm[Address+2] <= DataWr[23:16];
                dm[Address+3] <= DataWr[31:24]; */
                dm[Address]   <= 2'b00; // Corregido
                dm[Address+1] <= 2'b00;
                dm[Address+2] <= 2'b00;
                dm[Address+3] <= 2'b00;
            end
            default: begin
                // No write operation
            end
        endcase
    end

endmodule