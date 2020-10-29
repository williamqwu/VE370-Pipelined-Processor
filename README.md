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
- Functionality units
  - PC `[clock]`
    - beq
    - bne
    - j
  - **Instruction Memory** `[clock]`
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
  - Adder
  - MUX (*different size*)
  - Clock divider
  - ssd
  - Testbench
- Driver program
  - pipelined driver

## Work Distribution
@**?**(whoever finishes single processor) system structure <br>
@**xjy** patch for pipelined system <br>
@**ygc** forwarding unit, FPGA implementation <br>
@**lyr** hazard detection unit <br>
@**wqh** synthesis, FPGA implementation, RTL schematic <br>
@TBD report <br>
@TBD bonus <br>
