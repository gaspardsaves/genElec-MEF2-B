#ifndef AVL_H
    #define AVL_H
    #include <stddef.h>
    #include "structures.h"

    ElecEntity* RotateRight(ElecEntity* Tree);
    ElecEntity* RotateLeft(ElecEntity* Tree);
    ElecEntity* BringBalance(ElecEntity* Tree);
    ElecEntity* create(int id, long capacity, long consumption);
    ElecEntity* insert(ElecEntity* pHead, int id, long capacity, long consumption, int* h);
    void FreeTree(ElecEntity* Tree);

#endif