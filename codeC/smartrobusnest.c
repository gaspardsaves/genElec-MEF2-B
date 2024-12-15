#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "smartrobusnest.h"

//  Verify if the pointeur is not NULL
void verifPointer(void* p){
    if (p==NULL){
        printf("%d\n", errno);
        fprintf(stderr, "Pointeur nul\n");
        exit(1);
    }
}