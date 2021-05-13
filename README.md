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

## 测试

目前的指令：你可以根据需要修改

```
addi a0,x0,1
beq x0,x0,end
addi a0,a0,1
loop:
	xor a2,a0,a0
	andi a3,a0,0x3
	ori a4,a0,0x3
	sw a0,0(x0)
	lw a1,0(x0)
	addi a0,a0,1
end: 	j loop
```

通过开关SW修改CPU运行状态：

| 按键       | 内容 | 状态                               |
| ---------- | ---- | ---------------------------------- |
| SW[8]SW[2] | 00   | CPU全速时钟 100MHZ                 |
| SW[8]SW[2] | 01   | CPU自动单步时钟(2*24分频)          |
| SW[8]SW[2] | 1X   | CPU手动单步时钟(按键BTN_OK[0] M18) |


VGA会显示寄存器的状态

## 中断

本次实验的CSR：

| CSR   | 进入操作                                    | 返回操作   |
| ----- | ------------------------------------------- | ---------- |
| mtvec | [R] 读取跳转位置                            | -          |
| mepc  | [W] 存储PC+4<br />[!] 这是不符合RISCV标准的 | [R] 读取PC |

​	