python ./parser/assembler.py ./tests/Test.asm ./parser/instructions.json
cargo build
cargo run output.mem -h
iverilog -o bin\scc_tb.vvp Top-Level\SCC_tb.v Top-Level\SCC.v Top-Level\IF.v mem\Instruction_and_data.v Top-Level\RegFile.v Top-Level\ID.v Top-Level\EX.v
vvp bin\scc_tb.vvp -lx2 > run.log
python SelfChecker.py -s scc_dump.csv -v memoutput.csv
gtkwave dump.lx2 urmom.gtkw