(__TEXT,__text) section
_main:
0000000100003ea0        pushq   %rbp
0000000100003ea1        movq    %rsp, %rbp
0000000100003ea4        pushq   %rbx
0000000100003ea5        pushq   %rax
0000000100003ea6        leaq    0xf9(%rip), %rbx
0000000100003ead        nopl    (%rax)
0000000100003eb0        movq    %rbx, %rdi
0000000100003eb3        xorl    %esi, %esi
0000000100003eb5        xorl    %eax, %eax
0000000100003eb7        callq   0x100003f84
0000000100003ebc        movq    %rbx, %rdi
0000000100003ebf        movl    $0x1, %esi
0000000100003ec4        xorl    %eax, %eax
0000000100003ec6        callq   0x100003f84
0000000100003ecb        movq    %rbx, %rdi
0000000100003ece        movl    $0x1, %esi
0000000100003ed3        xorl    %eax, %eax
0000000100003ed5        callq   0x100003f84
0000000100003eda        movq    %rbx, %rdi
0000000100003edd        movl    $0x2, %esi
0000000100003ee2        xorl    %eax, %eax
0000000100003ee4        callq   0x100003f84
0000000100003ee9        movq    %rbx, %rdi
0000000100003eec        movl    $0x3, %esi
0000000100003ef1        xorl    %eax, %eax
0000000100003ef3        callq   0x100003f84
0000000100003ef8        movq    %rbx, %rdi
0000000100003efb        movl    $0x5, %esi
0000000100003f00        xorl    %eax, %eax
0000000100003f02        callq   0x100003f84
0000000100003f07        movq    %rbx, %rdi
0000000100003f0a        movl    $0x8, %esi
0000000100003f0f        xorl    %eax, %eax
0000000100003f11        callq   0x100003f84
0000000100003f16        movq    %rbx, %rdi
0000000100003f19        movl    $0xd, %esi
0000000100003f1e        xorl    %eax, %eax
0000000100003f20        callq   0x100003f84
0000000100003f25        movq    %rbx, %rdi
0000000100003f28        movl    $0x15, %esi
0000000100003f2d        xorl    %eax, %eax
0000000100003f2f        callq   0x100003f84
0000000100003f34        movq    %rbx, %rdi
0000000100003f37        movl    $0x22, %esi
0000000100003f3c        xorl    %eax, %eax
0000000100003f3e        callq   0x100003f84
0000000100003f43        movq    %rbx, %rdi
0000000100003f46        movl    $0x37, %esi
0000000100003f4b        xorl    %eax, %eax
0000000100003f4d        callq   0x100003f84
0000000100003f52        movq    %rbx, %rdi
0000000100003f55        movl    $0x59, %esi
0000000100003f5a        xorl    %eax, %eax
0000000100003f5c        callq   0x100003f84
0000000100003f61        movq    %rbx, %rdi
0000000100003f64        movl    $0x90, %esi
0000000100003f69        xorl    %eax, %eax
0000000100003f6b        callq   0x100003f84
0000000100003f70        movq    %rbx, %rdi
0000000100003f73        movl    $0xe9, %esi
0000000100003f78        xorl    %eax, %eax
0000000100003f7a        callq   0x100003f84
0000000100003f7f        jmp     0x100003eb0