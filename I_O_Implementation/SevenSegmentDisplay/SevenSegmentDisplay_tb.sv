/**
 * Testbench para SevenSegmentDisplay
 * Prueba todos los dígitos hexadecimales (0-F)
 */
`timescale 1ns/1ps

module SevenSegmentDisplay_tb;

    logic [3:0] hex_value;
    logic [6:0] segments;
    
    // Instanciar el módulo bajo prueba
    SevenSegmentDisplay dut (
        .hex_value(hex_value),
        .segments(segments)
    );
    
    // Estímulos
    initial begin
        $display("====================================");
        $display("  Seven Segment Display Test");
        $display("====================================");
        $display("Hex | Segments (gfedcba)");
        $display("----|-------------------");
        
        // Probar todos los valores hexadecimales
        for (int i = 0; i < 16; i++) begin
            hex_value = i[3:0];
            #10;
            $display(" %h  | %b", hex_value, segments);
        end
        
        $display("====================================");
        $display("✅ Test completado");
        $display("====================================");
        
        $finish;
    end
    
    // Generar archivo VCD para visualización
    initial begin
        $dumpfile("I_O_Implementation/SevenSegmentDisplay/SevenSegmentDisplay_tb.vcd");
        $dumpvars(0, SevenSegmentDisplay_tb);
    end

endmodule
