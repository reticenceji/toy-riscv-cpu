## 如何使用

第一次用Git管理Vivado工程。

要利用tcl脚本。打开vivado console，利用`pwd`和`cd`进入所在目录，`source tcl脚本`，就会在当前目录下生成工程文件。

需要给板子连上VGA，然后VGA会显示相关的CPU信息。

要执行指令，需要修改 MyIP2SOC.srcs/sources_1/ip/dist_mem_gen_0/I_mem.coe 文件。推荐一个[在线编译器](https://venus.cs61c.org/)
## CPU说明

CPU文件：IP2CPU

单周期。

对应的板子型号：NEXYS A7。xc7a100tcsg324-2L。

支持RISCV的少数指令：
jal beq sw lw 
add addi 
sub subi
or ori
and andi
xor xori
slt slti (小于时置位)
nor nori
srl srli (逻辑右移)
