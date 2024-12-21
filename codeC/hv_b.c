#include <stdio.h>

float Ratio(long Consumption, long Capacity){
    return Consumption/Capacity;
}

int main(){
    long Consumption, Capacity;
    while(scanf("%ld:%ld", &Consumption, &Capacity)==2){
        printf("%f\n", Ratio(Consumption, Capacity));
    }
    return 0;
}