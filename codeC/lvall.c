#include <stdio.h>

// Calculating the absolute energy consumption
long Ratio(long capacity, long consumption){
    return capacity-consumption;
}

int main(){
    int id;
    long capacity, consumption;
    // Reading values, calculating ratio and writing it in output file
    while (scanf("%d:%ld:%ld", &id, &capacity, &consumption) == 3){
        printf("%d:%ld:%ld:%ld\n", id, capacity, consumption, Ratio(capacity, consumption));
    }
    return 0;
}