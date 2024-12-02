#ifndef AVL_H
    #define AVL_H
    #include "structures.h"

    ElecEntity* RotateRight(ElecEntity* Tree);
    ElecEntity* RotateLeft(ElecEntity* Tree);
    ElecEntity* BringBalance(ElecEntity* Tree);
    int check(ElecEntity* Tree);
    ElecEntity* create(int id, int capacity, int consumption);
    ElecEntity* insert(ElecEntity* pHead, int id, int capacity, int consumption, int* h);
    void PrintPrefix(ElecEntity* Tree);
    
    int main();

#endif