python ./parser/assembler.py ./tests/Test.asm ./parser/instructions.json
iverilog -o bin\scc_tb.vvp Top-Level\SCC_tb.v Top-Level\SCC.v Top-Level\IF.v mem\Instruction_and_data.v Top-Level\RegFile.v Top-Level\ID.v
vvp bin\scc_tb.vvp -lx2 > run.log
gtkwave dump.lx2