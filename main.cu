
#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>
#include <string.h>
#define MAX 32

 

__global__ void toggle_case(char *x, char *y)
{
int i=threadIdx.x;
if(x[i] >= 'a' && x[i] <='z')
y[i] = x[i]-32;
else
if(x[i] >= 'A' && x[i] <='Z')
y[i] = x[i]+32;
else
{
y[i] = x[i];
}
}

 

int main()
{
int n;
cudaEvent_t start, stop;
float time;
char A[MAX],B[MAX],*d,*e;
printf("Enter String to be toggled: ");
scanf("%s",A);
n = strlen(A)+1;
cudaEventCreate(&start);
cudaEventCreate(&stop);
cudaMalloc((void **)&d,n*sizeof(char));
cudaMalloc((void **)&e,n*sizeof(char));
cudaMemcpy(d,A,n*sizeof(char),cudaMemcpyHostToDevice);
cudaEventRecord(start, 0);
toggle_case<<<1,n>>>(d,e);
cudaEventRecord(stop, 0);
cudaEventSynchronize(stop);
cudaMemcpy(B,e,n*sizeof(char),cudaMemcpyDeviceToHost);
printf("The toggled case String is %s", B);
printf("\n");
cudaFree(d);
cudaFree(e);
cudaEventElapsedTime(&time, start, stop);
printf ("Time for the kernel: %f ms\n", time);
return 0;
}
