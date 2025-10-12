module RegistersUnit(
    input logic clk,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,

    input logic [31:0] DataWR,
    input logic RUWr, // read 0 / write 1

    output logic [31:0] ru_rs1,
    output logic [31:0] ru_rs2
);
    // register matrix
    logic [31:0] ru [31:0]; // 32 registers of 32 bits each

    // lecturas con forwarding y x0 forzado a 0
    assign ru_rs1 = (rs1 == 0) ? 32'd0 :
                    ((RUWr && rd != 0 && rd == rs1) ? DataWR : ru[rs1]); // forwarding: if you try to read and write the same register, then assign DataWR to ru_rs1 temporarily
    assign ru_rs2 = (rs2 == 0) ? 32'd0 :
                    ((RUWr && rd != 0 && rd == rs2) ? DataWR : ru[rs2]);

    always @(posedge clk) begin
        if (RUWr && rd != 0) begin
            ru[rd] <= DataWR;
        end 
    end
endmodule