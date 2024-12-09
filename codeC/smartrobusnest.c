#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "smartrobusnest.h"

//  Verify if the pointeur is not NULL
void verifpointer(void* p){
    if (p==NULL){
        printf("%d\n", errno);
        fprintf(stderr, "Pointeur nul\n");
        exit(1);
    }
}

// Check if a file is opened successfully 
void checkOpenFile(FILE* f){
    if (f==NULL){
        printf("%d\n", errno);
        fprintf(stderr, "Erreur lors de l'ouverture du fichier\n");
        exit(2);
    }
}

// Check if a wrinting to a file is successful
void checkWritingFile(int writeReturn){
    if (writeReturn==EOF){
        printf("%d\n", errno);
        fprintf(stderr, "Erreur lors de l'écriture d'une ligne\n");
        exit(3);
    }
}

// Check if a file is closed succesfully 
void checkCloseFile(int closeReturn){
    if (closeReturn==EOF){
        printf("%d\n", errno);
        fprintf(stderr, "Erreur lors de la fermeture d'un flux\n");
        exit(4);
    }
}

// Safely scan an int value
int better_scan(char * message){
    int ret_var = 0;
    int value = 1;
  while (ret_var != 1 || value < 0)
    {   
        printf("%s", message);
        ret_var = scanf("%d", &value);
        while(getchar()!='\n'){} // Clear the input buffer
    }
    return value;
}

// Safely scan a float value
float better_scanFloat(char * message){
    int ret_var = 0;
    float value = 1;
  while (ret_var != 1 || value < 0)
    {   
        printf("%s", message);
        ret_var = scanf("%f", &value);
        while(getchar()!='\n'){} // Clear the input buffer
    }
    return value;
}

// Safely scan an unsigned value
unsigned better_scanUn(char * message){
    int ret_var = 0;
    unsigned value = 1;
  while (ret_var != 1)
    {   
        printf("%s", message);
        ret_var = scanf("%d", &value);
        while(getchar()!='\n'){} // Clear the input buffer
    }
    return value;
}