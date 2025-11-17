/**
 * Testbench para DisplayController
 * Prueba el controlador de 8 displays mostrando varios valores
 */
`timescale 1ns/1ps

module DisplayController_tb;

    logic [31:0] data_to_display;
    logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;
    
    // Instanciar el módulo bajo prueba
    DisplayController dut (
        .data_to_display(data_to_display),
        .hex0(hex0),
        .hex1(hex1),
        .hex2(hex2),
        .hex3(hex3),
        .hex4(hex4),
        .hex5(hex5),
        .hex6(hex6),
        .hex7(hex7)
    );
    
    // Estímulos
    initial begin
        $display("====================================================");
        $display("  Display Controller Test");
        $display("====================================================");
        $display("Data (32-bit)   | HEX7 HEX6 HEX5 HEX4 HEX3 HEX2 HEX1 HEX0");
        $display("----------------|---------------------------------------");
        
        // Caso 1: 0x00000000
        data_to_display = 32'h00000000;
        #10;
        $display("0x%h | %b %b %b %b %b %b %b %b", 
                 data_to_display, hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0);
        
        // Caso 2: 0x12345678
        data_to_display = 32'h12345678;
        #10;
        $display("0x%h | %b %b %b %b %b %b %b %b", 
                 data_to_display, hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0);
        
        // Caso 3: 0xABCDEF00
        data_to_display = 32'hABCDEF00;
        #10;
        $display("0x%h | %b %b %b %b %b %b %b %b", 
                 data_to_display, hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0);
        
        // Caso 4: 0xFFFFFFFF
        data_to_display = 32'hFFFFFFFF;
        #10;
        $display("0x%h | %b %b %b %b %b %b %b %b", 
                 data_to_display, hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0);
        
        // Caso 5: 0xDEADBEEF
        data_to_display = 32'hDEADBEEF;
        #10;
        $display("0x%h | %b %b %b %b %b %b %b %b", 
                 data_to_display, hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0);
        
        $display("====================================================");
        $display("✅ Test completado");
        $display("====================================================");
        
        $finish;
    end
    
    // Generar archivo VCD
    initial begin
        $dumpfile("I_O_Implementation/SevenSegmentDisplay/DisplayController_tb.vcd");
        $dumpvars(0, DisplayController_tb);
    end

endmodule
