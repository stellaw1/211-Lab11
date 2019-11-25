#define N 128
double A[N][N], B[N][N], C[N][N];
void matrix_multiply(void)
{
int i, j, k;
for( i=0; i<N; i++ ) {
for( j=0; j<N; j++ ) {
double sum=0.0;
for( k=0; k<N; k++ ) {
sum = sum + A[i][k] * B[k][j]; }
C[i][j] = sum; } }
}