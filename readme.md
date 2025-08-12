# C to Assembly: Comparing Compiler Optimization

This project is a hands-on exploration of how a C compiler translates a simple program into machine-readable assembly code. It demonstrates the dramatic difference between an unoptimized and an optimized build, inspired by the concepts shown in this YouTube video: [[Comparing C to machine language](https://youtu.be/yOyaJXpAYZQ?si=uGS71liOFi94eSz7)].

The C program, `fib.c`, calculates and prints the Fibonacci sequence in an infinite loop. By compiling it with and without optimization flags, we can see how the compiler can be "smarter" than the code it's given.

```c
#include <stdio.h>

int main(void) {
    int x, y, z;

    while (1) {
        x = 0;
        y = 1;
        do {
            printf("%d\n", x);
            z = x + y;
            x = y;
            y = z;
        } while (x < 255);
    }
}
```

## Key Findings: Unoptimized vs. Optimized Code

### 1. Unoptimized Build (`-O0`)

When compiled with no optimization, the resulting assembly code is a very direct, literal translation of the C source.

*   **Line-by-Line Translation:** Each C statement (like `x = y;` or `z = x + y;`) has a corresponding set of assembly instructions.
*   **Use of Stack:** Variables (`x`, `y`, `z`) are stored on the stack and are frequently moved back and forth between memory and CPU registers.
*   **Runtime Calculation:** All arithmetic (`addl`) and comparisons (`cmpl`) are performed at runtime, every single time the loop runs.

```assembly
_main:
; --- Function Setup ---
0000000100003f30        pushq   %rbp
0000000100003f31        movq    %rsp, %rbp
0000000100003f34        subq    $0x10, %rsp       ; Make space on stack for x, y, z
0000000100003f38        movl    $0x0, -0x4(%rbp)  ; Boilerplate: set main's return value to 0

; --- while(1) loop starts here ---
0000000100003f3f        movl    $0x0, -0x8(%rbp)  ; x = 0
0000000100003f46        movl    $0x1, -0xc(%rbp)  ; y = 1

; --- do-while loop starts here ---
0000000100003f4d        movl    -0x8(%rbp), %esi  ; Prepare x for printf
0000000100003f50        leaq    0x4f(%rip), %rdi  ; Prepare format string for printf
0000000100003f57        movb    $0x0, %al         ; Boilerplate for printf call
0000000100003f59        callq   0x100003f86       ; call printf
0000000100003f5e        movl    -0x8(%rbp), %eax  ; z = x + y (eax = x)
0000000100003f61        addl    -0xc(%rbp), %eax  ; z = x + y (eax = eax + y)
0000000100003f64        movl    %eax, -0x10(%rbp) ; z = result
0000000100003f67        movl    -0xc(%rbp), %eax  ; x = y
0000000100003f6a        movl    %eax, -0x8(%rbp)
0000000100003f6d        movl    -0x10(%rbp), %eax ; y = z
0000000100003f70        movl    %eax, -0xc(%rbp)
0000000100003f73        cmpl    $0xff, -0x8(%rbp) ; compare x with 255
0000000100003f7a        jl      0x100003f4d       ; if less, jump to start of do-while
0000000100003f80        jmp     0x100003f3f       ; jump to start of while(1)
```

### 2. Optimized Build (`-O2`)

When compiled with a standard optimization level (`-O2`), the compiler analyzes the code's behavior and completely transforms it.

*   **Loop Unrolling & Constant Folding:** The compiler recognized that the `do-while` loop's behavior is predictable. It executed the loop *at compile time*, calculated all the Fibonacci numbers less than 255, and replaced the entire loop with a simple, hardcoded sequence of `printf` calls.
*   **No Runtime Calculation:** The optimized assembly code contains **no arithmetic (`addl`) or comparison (`cmpl`) instructions** for the Fibonacci sequence. The numbers are already known.
*   **Efficiency:** This version is significantly faster because it eliminates redundant calculations, memory access, and conditional jumps at runtime.

```assembly
_main:
; --- Function Setup ---
0000000100003ea0        pushq   %rbp
0000000100003ea1        movq    %rsp, %rbp
0000000100003ea4        pushq   %rbx              ; Save %rbx register because we're going to use it
...
; --- Prepare the format string ONCE ---
0000000100003ea6        leaq    0xf9(%rip), %rbx  ; Load address of "%d\n" into %rbx and keep it there

; --- The outer while(1) loop starts here ---
0000000100003ead        nopl    (%rax)            ; No-op for alignment
0000000100003eb0        ; The compiler has completely unrolled your do-while loop!
                        ; It pre-calculated all the Fibonacci numbers < 255.

; --- Print 0 ---
0000000100003eb0        movq    %rbx, %rdi        ; Arg 1: format string
0000000100003eb3        xorl    %esi, %esi        ; Arg 2: the number 0 (xor is a fast way to zero a register)
0000000100003eb5        xorl    %eax, %eax        ; Boilerplate for printf
0000000100003eb7        callq   0x100003f84       ; call printf

; --- Print 1 ---
0000000100003ebc        movq    %rbx, %rdi        ; Arg 1: format string
0000000100003ebf        movl    $0x1, %esi        ; Arg 2: the number 1
...
0000000100003ec6        callq   0x100003f84       ; call printf

; --- Print 1 ---
0000000100003ecb        movq    %rbx, %rdi
0000000100003ece        movl    $0x1, %esi
...
0000000100003ed5        callq   0x100003f84

; --- Print 2 ---
0000000100003eda        movq    %rbx, %rdi
0000000100003edd        movl    $0x2, %esi
...
0000000100003ee4        callq   0x100003f84

; --- And so on... printing 3, 5, 8, 13 (0xd), 21 (0x15), 34 (0x22),
; --- 55 (0x37), 89 (0x59), 144 (0x90), and 233 (0xe9) ---

; --- After printing all the pre-calculated numbers... ---
0000000100003f7f        jmp     0x100003eb0       ; Jump back to the top to do it all again (the while(1) loop)
```

## How to Replicate This Yourself

Follow the instructions for your operating system to compile and inspect the code.

### macOS

1.  **Compile with NO optimization:**
    ```bash
    clang -O0 -o fib_no_opt fib.c
    ```
2.  **View the unoptimized assembly:**
    ```bash
    otool -tv fib_no_opt
    ```
3.  **Compile WITH optimization:**
    ```bash
    clang -O2 -o fib_opt fib.c
    ```
4.  **View the optimized assembly:**
    ```bash
    otool -tv fib_opt
    ```

### Linux

1.  **Compile with NO optimization:**
    ```bash
    gcc -O0 -o fib_no_opt fib.c
    ```
2.  **View the unoptimized assembly:**
    ```bash
    objdump -d fib_no_opt
    ```
3.  **Compile WITH optimization:**
    ```bash
    gcc -O2 -o fib_opt fib.c
    ```
4.  **View the optimized assembly:**
    ```bash
    objdump -d fib_opt
    ```

### Windows

1.  **Compile with NO optimization:**
    ```bash
    gcc -O0 -o fib_no_opt.exe fib.c
    ```
2.  **View the unoptimized assembly:**
    ```bash
    objdump -d fib_no_opt.exe
    ```
3.  **Compile WITH optimization:**
    ```bash
    gcc -O2 -o fib_opt.exe fib.c
    ```
4.  **View the optimized assembly:**
    ```bash
    objdump -d fib_opt.exe
    ```