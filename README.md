# VE370 Project2
*A pipelined processor with hazard detection for the course VE370 from UM-SJTU JI.*

## Contributors
Group ID: 20 <br>
Group Member: <br>
- Gengchen Yang
- Jiaying Xu
- Qinhang Wu
- Yuru Liu

## Checklist
### Modules
- Functionality units
  - PC `[clock]`
    - beq
    - bne
    - j
  - Instruction Memory
  - **Register** `[clock]`
  - ALU
    - add
    - sub
    - and
    - or
    - slt
    - addi
    - andi
  - **Data Memory** `[clock]`
  - Sign-extended
  - **Pipeline Register** `[clock]`
- Control units
  - Control
  - Forwarding unit
  - Hazard Detection unit
- MISC
  - Clock divider
  - ssd
- Data Bus
  - pipelined driver
- Driver program
  - testbench
  - ssd driver

### Signals
  - input RegDst      // EX
  - input Jump        // MEM
  - input Branch      // MEM
  - input Bne         // MEM
  - input MemRead     // MEM
  - input MemtoReg    // WB
  - input [1:0] ALUOp // EX
  - input MemWrite    // MEM 
  - input ALUSrc      // EX
  - input RegWrite    // WB

## Work Distribution
@*(whoever finishes single processor)* system structure <br>
@**xjy** patch for pipelined system <br>
@**ygc** forwarding unit, FPGA implementation <br>
@**lyr** hazard detection unit <br>
@**wqh** debug, synthesis, FPGA implementation <br>
@**xjy/lyr** RTL schematic <br>
@~~report LaTeX https://www.overleaf.com/1952724924yppjbdyhxccp~~ <br>
@report MD https://notes.sjtu.edu.cn/wlJIp9r3QciijvoDd4lb7g <br>
@**lyr** bonus <br>

## Note for Tricky Issues regarding Verilog
1. `{16{1'b1}}` vs. `16'b1`
2. delay in `initial`
3. sync vs async (which unit need to be controlled by `clk`)
4. `reg` is only for a 2-bit number
5. *Nothing more. The rest is just a LinkGame.*

## Release
| Bit | Commit Hash |
| --- | ----------- |
| driver_1358.bit | 4189f856d61629a9d95b7a33ac307b1ca5e337ad |

