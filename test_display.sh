#!/bin/bash
# Script para probar los módulos de 7 segmentos

echo "======================================"
echo "  Testing Seven Segment Modules"
echo "======================================"
echo ""

# Test 1: SevenSegmentDisplay
echo "1️⃣  Testing SevenSegmentDisplay..."
iverilog -g2012 -o ssd_test.out \
    I_O_Implementation/SevenSegmentDisplay/SevenSegmentDisplay.sv \
    I_O_Implementation/SevenSegmentDisplay/SevenSegmentDisplay_tb.sv

if [ $? -eq 0 ]; then
    echo "   ✅ Compilation successful"
    vvp ssd_test.out
    rm -f ssd_test.out
else
    echo "   ❌ Compilation failed"
    exit 1
fi

echo ""
echo "======================================"
echo ""

# Test 2: DisplayController
echo "2️⃣  Testing DisplayController..."
iverilog -g2012 -o dc_test.out \
    I_O_Implementation/SevenSegmentDisplay/SevenSegmentDisplay.sv \
    I_O_Implementation/SevenSegmentDisplay/DisplayController.sv \
    I_O_Implementation/SevenSegmentDisplay/DisplayController_tb.sv

if [ $? -eq 0 ]; then
    echo "   ✅ Compilation successful"
    vvp dc_test.out
    rm -f dc_test.out
else
    echo "   ❌ Compilation failed"
    exit 1
fi

echo ""
echo "======================================"
echo "  All tests completed successfully!"
echo "======================================"
