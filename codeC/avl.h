#ifndef AVL_H
    #define AVL_H
    #include <stddef.h>
    #include "structures.h"

    ElecEntity* RotateRight(ElecEntity* Tree);
    ElecEntity* RotateLeft(ElecEntity* Tree);
    ElecEntity* BringBalance(ElecEntity* Tree);
    ElecEntity* create(int id, int capacity, int consumption);
    ElecEntity* insert(ElecEntity* pHead, int id, int capacity, int consumption, int* h);
    void PrintPrefix(ElecEntity* Tree);
    void FreeTree(ElecEntity* Tree);

    int main();

#endif