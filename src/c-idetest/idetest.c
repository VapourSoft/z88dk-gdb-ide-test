#include <stdio.h>
#include <stdint.h>

char sum(char a, char b)
{
    return a + b; 
}

uint8_t total = 0;

uint8_t main(void)
{               
    char a = 0; 
    char b = 0; 

    for (int i = 0; i < 10; i++)
    {
        a += 1; 
        total += a;
    }

    char s = sum(a, b); 
    printf("%d + %d = %d\n", a, b, s); 
    return 0;
} 
