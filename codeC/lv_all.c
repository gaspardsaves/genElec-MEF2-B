#include <stdio.h>
#include "color.h"

long Ratio(long capacity, long consumption){
    return capacity-consumption;
}

int main(){
    int id;
    long capacity, consumption;
    while (scanf("%d:%ld:%ld", &id, &capacity, &consumption) == 3){
        if(Ratio(capacity, consumption)<0){
            color("32");
        }
        if(Ratio(capacity, consumption)>=0){
            color("33");
        }
        printf("%d:%ld:%ld:%ld\n", id, capacity, consumption, Ratio(capacity, consumption));
    }
    return 0;
}