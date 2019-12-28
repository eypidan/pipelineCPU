# Pipeline CPU
浙江大学体系结构课程流水线CPU(Jiang XiaoHong Class)
### Feature
- 5-stage pipeline
    - only need to consider RAW(read after write) about data hazard
    - avoid structure hazard
- MIPS architecture
- could detect exception about overflow, undefined instruction, out of range memory access
- could interrupt by outside signal (like SW switch in SWORD) 
- could forwarding to reduce unnecessary stall

### Schematic
#### version1
- flushing pipeline to deal with hazard
- without forwarding
- code -> release v1.0

#### version2(branch baselineCPU)
- forwarding CPU

#### version3(branch interrupt CPU)
- add exception and interrupt of CPU
- add CP0 structure
#### version 4
- read inst_rom for 8 cycles
- read/write data_ram for 8 cycles
