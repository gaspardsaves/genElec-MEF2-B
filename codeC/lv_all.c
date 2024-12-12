#include <stdio.h>
#include <stdlib.h>

#include "structures.h"
#include "smartrobusnest.h"
#include "avl.h"

int Ratio(int capacity, int consumption){
    return consumption-capacity;
}

int main(){
    int id, capacity, consumption;
    while (scanf("%d;%d;%d", &id, &capacity, &consumption) == 3){
        printf("%d;%d", id, Ratio(capacity, consumption,)");
    }
    return 0;
}