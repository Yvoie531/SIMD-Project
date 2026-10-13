#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <windows.h>

extern double asum_x64(int n, double* A);
extern double asum_xmm(int n, double* A);
extern double asum_ymm(int n, double* A);

double asum_c(int n, double* A) {
    double asum = 0.0;
    for (int i = 0; i < n; i++)
        asum += fabs(A[i]);
    return asum;
}

int main(void) {
    int sizes[] = { 1003, 1 << 20, 1 << 26, 1 << 30 };
    const char* names[] = { "C", "x86-64", "SIMD XMM", "SIMD YMM" };
    double (*kernels[])(int, double*) = { asum_c, asum_x64, asum_xmm, asum_ymm };
    LARGE_INTEGER freq, start, end;
    QueryPerformanceFrequency(&freq);

    for (int s = 0; s < 4; s++) {
        int n = sizes[s];
        double* A = malloc((size_t)n * sizeof(double));
        if (A == NULL) {
            printf("Not enough memory for n = %d\n", n);
            return 1;
        }
        for (int i = 0; i < n; i++)
            A[i] = (i % 1000) - 500.5;

        printf("\nn = %d\n", n);
        double answer_key = 0.0;
        for (int k = 0; k < 4; k++) {
            double asum = 0.0;
            long long ticks = 0;
            for (int run = 0; run < 30; run++) {
                QueryPerformanceCounter(&start);
                asum = kernels[k](n, A);
                QueryPerformanceCounter(&end);
                ticks += end.QuadPart - start.QuadPart;
            }
            if (k == 0)
                answer_key = asum;
            printf("%-9s asum = %.1f   average time = %.4f ms   %s\n", names[k], asum,
                ticks * 1000.0 / freq.QuadPart / 30,
                k == 0 ? "(answer key)" : asum == answer_key ? "correct" : "INCORRECT");
        }
        free(A);
    }
    return 0;
}
