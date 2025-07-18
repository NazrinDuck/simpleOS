    .align 4
    .section .data
    .global _app_num
_app_num:
    .quad 39
    .quad app_0_start
    .quad app_1_start
    .quad app_2_start
    .quad app_3_start
    .quad app_4_start
    .quad app_5_start
    .quad app_6_start
    .quad app_7_start
    .quad app_8_start
    .quad app_9_start
    .quad app_10_start
    .quad app_11_start
    .quad app_12_start
    .quad app_13_start
    .quad app_14_start
    .quad app_15_start
    .quad app_16_start
    .quad app_17_start
    .quad app_18_start
    .quad app_19_start
    .quad app_20_start
    .quad app_21_start
    .quad app_22_start
    .quad app_23_start
    .quad app_24_start
    .quad app_25_start
    .quad app_26_start
    .quad app_27_start
    .quad app_28_start
    .quad app_29_start
    .quad app_30_start
    .quad app_31_start
    .quad app_32_start
    .quad app_33_start
    .quad app_34_start
    .quad app_35_start
    .quad app_36_start
    .quad app_37_start
    .quad app_38_start
    .quad app_38_end

    .global _app_names
_app_names:
   .string "ch2b_exit"
   .string "ch2b_hello_world"
   .string "ch2b_power"
   .string "ch3_taskinfo"
   .string "ch3b_sleep"
   .string "ch3b_sleep1"
   .string "ch3b_yield0"
   .string "ch3b_yield1"
   .string "ch3b_yield2"
   .string "ch4_mmap0"
   .string "ch4_mmap1"
   .string "ch4_mmap2"
   .string "ch4_mmap3"
   .string "ch4_sbrk"
   .string "ch4_unmap0"
   .string "ch4_unmap1"
   .string "ch5_exit0"
   .string "ch5_exit1"
   .string "ch5_mergetest"
   .string "ch5_ppid"
   .string "ch5_setprio"
   .string "ch5_spawn0"
   .string "ch5_spawn1"
   .string "ch5_usertest"
   .string "ch5b_exec_simple"
   .string "ch5b_exit"
   .string "ch5b_forktest0"
   .string "ch5b_forktest1"
   .string "ch5b_forktest2"
   .string "ch5b_getpid"
   .string "ch5b_usertest"
   .string "ch5t_stride0"
   .string "ch5t_stride1"
   .string "ch5t_stride2"
   .string "ch5t_stride3"
   .string "ch5t_stride4"
   .string "ch5t_stride5"
   .string "ch5t_usertest"
   .string "usershell"

    .global INIT_PROC
INIT_PROC:
    .string "usershell"

    .section .data.app0
    .global app_0_start
app_0_start:
    .incbin "./user/target/bin/ch2b_exit"

    .section .data.app1
    .global app_1_start
app_1_start:
    .incbin "./user/target/bin/ch2b_hello_world"

    .section .data.app2
    .global app_2_start
app_2_start:
    .incbin "./user/target/bin/ch2b_power"

    .section .data.app3
    .global app_3_start
app_3_start:
    .incbin "./user/target/bin/ch3_taskinfo"

    .section .data.app4
    .global app_4_start
app_4_start:
    .incbin "./user/target/bin/ch3b_sleep"

    .section .data.app5
    .global app_5_start
app_5_start:
    .incbin "./user/target/bin/ch3b_sleep1"

    .section .data.app6
    .global app_6_start
app_6_start:
    .incbin "./user/target/bin/ch3b_yield0"

    .section .data.app7
    .global app_7_start
app_7_start:
    .incbin "./user/target/bin/ch3b_yield1"

    .section .data.app8
    .global app_8_start
app_8_start:
    .incbin "./user/target/bin/ch3b_yield2"

    .section .data.app9
    .global app_9_start
app_9_start:
    .incbin "./user/target/bin/ch4_mmap0"

    .section .data.app10
    .global app_10_start
app_10_start:
    .incbin "./user/target/bin/ch4_mmap1"

    .section .data.app11
    .global app_11_start
app_11_start:
    .incbin "./user/target/bin/ch4_mmap2"

    .section .data.app12
    .global app_12_start
app_12_start:
    .incbin "./user/target/bin/ch4_mmap3"

    .section .data.app13
    .global app_13_start
app_13_start:
    .incbin "./user/target/bin/ch4_sbrk"

    .section .data.app14
    .global app_14_start
app_14_start:
    .incbin "./user/target/bin/ch4_unmap0"

    .section .data.app15
    .global app_15_start
app_15_start:
    .incbin "./user/target/bin/ch4_unmap1"

    .section .data.app16
    .global app_16_start
app_16_start:
    .incbin "./user/target/bin/ch5_exit0"

    .section .data.app17
    .global app_17_start
app_17_start:
    .incbin "./user/target/bin/ch5_exit1"

    .section .data.app18
    .global app_18_start
app_18_start:
    .incbin "./user/target/bin/ch5_mergetest"

    .section .data.app19
    .global app_19_start
app_19_start:
    .incbin "./user/target/bin/ch5_ppid"

    .section .data.app20
    .global app_20_start
app_20_start:
    .incbin "./user/target/bin/ch5_setprio"

    .section .data.app21
    .global app_21_start
app_21_start:
    .incbin "./user/target/bin/ch5_spawn0"

    .section .data.app22
    .global app_22_start
app_22_start:
    .incbin "./user/target/bin/ch5_spawn1"

    .section .data.app23
    .global app_23_start
app_23_start:
    .incbin "./user/target/bin/ch5_usertest"

    .section .data.app24
    .global app_24_start
app_24_start:
    .incbin "./user/target/bin/ch5b_exec_simple"

    .section .data.app25
    .global app_25_start
app_25_start:
    .incbin "./user/target/bin/ch5b_exit"

    .section .data.app26
    .global app_26_start
app_26_start:
    .incbin "./user/target/bin/ch5b_forktest0"

    .section .data.app27
    .global app_27_start
app_27_start:
    .incbin "./user/target/bin/ch5b_forktest1"

    .section .data.app28
    .global app_28_start
app_28_start:
    .incbin "./user/target/bin/ch5b_forktest2"

    .section .data.app29
    .global app_29_start
app_29_start:
    .incbin "./user/target/bin/ch5b_getpid"

    .section .data.app30
    .global app_30_start
app_30_start:
    .incbin "./user/target/bin/ch5b_usertest"

    .section .data.app31
    .global app_31_start
app_31_start:
    .incbin "./user/target/bin/ch5t_stride0"

    .section .data.app32
    .global app_32_start
app_32_start:
    .incbin "./user/target/bin/ch5t_stride1"

    .section .data.app33
    .global app_33_start
app_33_start:
    .incbin "./user/target/bin/ch5t_stride2"

    .section .data.app34
    .global app_34_start
app_34_start:
    .incbin "./user/target/bin/ch5t_stride3"

    .section .data.app35
    .global app_35_start
app_35_start:
    .incbin "./user/target/bin/ch5t_stride4"

    .section .data.app36
    .global app_36_start
app_36_start:
    .incbin "./user/target/bin/ch5t_stride5"

    .section .data.app37
    .global app_37_start
app_37_start:
    .incbin "./user/target/bin/ch5t_usertest"

    .section .data.app38
    .global app_38_start
app_38_start:
    .incbin "./user/target/bin/usershell"
app_38_end:

