/**
 * Display Controller
 * Controla múltiples displays de 7 segmentos para mostrar valores de 32 bits
 * 
 * @input  data_to_display => Dato de 32 bits a mostrar en hexadecimal
 * @output hex0-hex7       => Salidas para 8 displays de 7 segmentos
 * 
 * Distribución:
 * - HEX0: bits [3:0]   (nibble menos significativo)
 * - HEX1: bits [7:4]
 * - HEX2: bits [11:8]
 * - HEX3: bits [15:12]
 * - HEX4: bits [19:16]
 * - HEX5: bits [23:20]
 * - HEX6: bits [27:24]
 * - HEX7: bits [31:28] (nibble más significativo)
 * 
 * Ejemplo: data_to_display = 0x12345678
 *   HEX7 HEX6 HEX5 HEX4 HEX3 HEX2 HEX1 HEX0
 *    1    2    3    4    5    6    7    8
 */
module DisplayController(
    input logic [31:0] data_to_display,  // Dato a mostrar
    output logic [6:0] hex0,             // Display 0 (LSB)
    output logic [6:0] hex1,             // Display 1
    output logic [6:0] hex2,             // Display 2
    output logic [6:0] hex3,             // Display 3
    output logic [6:0] hex4,             // Display 4
    output logic [6:0] hex5,             // Display 5
    output logic [6:0] hex6,             // Display 6
    output logic [6:0] hex7              // Display 7 (MSB)
);

    // Instanciar 8 decodificadores de 7 segmentos
    // Cada uno maneja un nibble (4 bits) del dato
    SevenSegmentDisplay disp0 (
        .hex_value(data_to_display[3:0]),
        .segments(hex0)
    );

    SevenSegmentDisplay disp1 (
        .hex_value(data_to_display[7:4]),
        .segments(hex1)
    );

    SevenSegmentDisplay disp2 (
        .hex_value(data_to_display[11:8]),
        .segments(hex2)
    );

    SevenSegmentDisplay disp3 (
        .hex_value(data_to_display[15:12]),
        .segments(hex3)
    );

    SevenSegmentDisplay disp4 (
        .hex_value(data_to_display[19:16]),
        .segments(hex4)
    );

    SevenSegmentDisplay disp5 (
        .hex_value(data_to_display[23:20]),
        .segments(hex5)
    );

    SevenSegmentDisplay disp6 (
        .hex_value(data_to_display[27:24]),
        .segments(hex6)
    );

    SevenSegmentDisplay disp7 (
        .hex_value(data_to_display[31:28]),
        .segments(hex7)
    );

endmodule
