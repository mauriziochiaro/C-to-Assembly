#include <stdio.h>

int main(void) {
    int x, y, z;

    // This outer loop will cause the fibonacci sequence
    // to reset and print again forever.
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
    // Note: The program never reaches here, so it never exits.
}