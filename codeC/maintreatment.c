#include <stdio.h>
#include <stdlib.h>

#include "structures.h"
#include "smartrobusnest.h"
#include "avl.h"
#include "maintreatment.h"

// Print the three in the output file with a prefix process
void PrintPrefix(ElecEntity* Tree){
    if(Tree!=NULL){
        PrintPrefix(Tree->pLeft);
        printf("%d:%ld:%ld\n", Tree->id, Tree->capacity, Tree->consumption);
        PrintPrefix(Tree->pRight);
    }
}

int main(){
    ElecEntity* pTree = NULL;
    int id;
    long capacity, consumption;
    int* h = malloc(sizeof(int));
    verifPointer(h);
    // Reading values from input files and AVL insertion
    while (scanf("%d;%ld;%ld", &id, &capacity, &consumption) == 3) {
        pTree = insert(pTree, id, capacity, consumption, h);
    }
    // Writing in output file
    PrintPrefix(pTree);
    // Freeing allocated memory
    FreeTree(pTree);
    free(h);
    return 0;
}

/*// Test version

void PrintPrefix2(ElecEntity* Tree){
    if(Tree==NULL){
        return ;
    }
    PrintPrefix2(Tree->pLeft);
    printf("%d;%ld;%ld;%d\n", Tree->id, Tree->capacity, Tree->consumption, Tree->balanceFactor);
    PrintPrefix2(Tree->pRight);
}

int main(){
    ElecEntity* Tree = create(1, 160000, 1);
    int* h = malloc(sizeof(int));
    Tree = insert(Tree, 1, 0, 2000, h);
    Tree = insert(Tree, 2, 0, 2000, h);
    Tree = insert(Tree, 1, 0, 2000, h);
    Tree = insert(Tree, 1, 0, 2000, h);
    Tree = insert(Tree, 1, 0, 2000, h);
    Tree = insert(Tree, 3, 0, 2000, h);
    Tree = insert(Tree, 1, 0, 2000, h);
    Tree = insert(Tree, 1, 0, 2000, h);
    int i = 0;
    while(i<1000000){
        Tree = insert(Tree, i, 0, 2000, h);
        i++;
    }
    PrintPrefix2(Tree);
    FreeTree(Tree);
    free(h);
    return 0;
}
//*/