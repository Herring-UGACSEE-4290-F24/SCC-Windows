iverilog -o bin\scc_tb.vvp Top-Level\SCC_tb.v Top-Level\SCC.v Top-Level\IF.v Top-Level\InstrMem.v Top-Level\RegFile.v
vvp bin\scc_tb.vvp -lx2 > run.log
gtkwave dump.lx2