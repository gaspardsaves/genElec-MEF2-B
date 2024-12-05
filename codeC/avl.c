#include <stdio.h>
#include <stdlib.h>

#include "structures.h" 
#include "avl.h"

#define max(a,b) ((a)>(b) ? a : b)
#define min(a,b) ((a)<(b) ? a : b)

ElecEntity* RotateRight(ElecEntity* Tree){
    if(Tree==NULL){
        exit(1);
    }
    if(Tree->pLeft==NULL){
        exit(2);
    }
    int Balance_Tree = 0;
    int Balance_Pivot = 0;
    ElecEntity* Pivot = Tree->pLeft;
    Tree->pLeft = Pivot->pRight;
    Pivot->pRight = Tree;
    Balance_Tree = Tree->balanceFactor;
    Balance_Pivot = Pivot->balanceFactor;
    Tree->balanceFactor = Balance_Tree - min(Balance_Pivot, 0) + 1;
    Pivot->balanceFactor = max(max(Balance_Tree+2, Balance_Tree + Balance_Pivot + 2), Balance_Pivot+1 );
    Tree = Pivot;
    return Tree;
}



ElecEntity* RotateLeft(ElecEntity* Tree){
    if(Tree==NULL){
        exit(1);
    }
    if(Tree->pRight==NULL){
        exit(2);
    }
    int Balance_Tree = 0;
    int Balance_Pivot = 0;
    ElecEntity* Pivot = Tree->pRight;
    Tree->pRight = Pivot->pLeft;
    Pivot->pLeft = Tree;
    Balance_Tree = Tree->balanceFactor;
    Balance_Pivot = Pivot->balanceFactor;
    Tree->balanceFactor = Balance_Tree - max(Balance_Pivot, 0) - 1;
    Pivot->balanceFactor = min(min(Balance_Tree-2, Balance_Tree + Balance_Pivot - 2), Balance_Pivot-1 );
    Tree = Pivot;
    return Tree;
}

ElecEntity* BringBalance(ElecEntity* Tree){
    if(Tree==NULL){
        return Tree;
    }
    if(Tree->balanceFactor>=2){
        if(Tree->pRight->balanceFactor>=0){
            Tree = RotateLeft(Tree);
        }
        else{
            Tree->pRight = RotateRight(Tree->pRight);
            Tree = RotateLeft(Tree);
        }
    }
    else if(Tree->balanceFactor<=(-2)){
        if(Tree->pRight->balanceFactor<=0){
            Tree = RotateRight(Tree);
        }
        else{
            Tree->pLeft = RotateLeft(Tree->pLeft);
            Tree = RotateRight(Tree);
        }
    }
    return Tree;
}

int check(ElecEntity* Tree){
    if (Tree == NULL){
        exit(1);
    }
}

ElecEntity* create(int id, int capacity, int consumption, int powerPlant){
    ElecEntity* new = malloc(sizeof(ElecEntity));
    check(new);

    new->id = id;
    new->capacity = capacity;
    new->consumption = consumption;
    new->powerPlant = powerPlant;
    new->balanceFactor = 0;
    new->pLeft = NULL;
    new->pRight = NULL;

    return new;
}

ElecEntity* insert(ElecEntity* pHead, int id, int capacity, int consumption, int powerPlant, int* h){
    if(pHead == NULL){
        *h = 1;
        return create(id, capacity, consumption, powerPlant);
    }
    else if(id < pHead->id){
        pHead->pLeft = insert(pHead->pLeft, id, capacity, consumption, powerPlant, h);
        *h = (-1)*(*h);
    }
    else if(id > pHead->id){
        pHead->pRight = insert(pHead->pRight, id, capacity, consumption, powerPlant, h);
    }
    else{
        *h = 0;
        pHead->consumption += consumption;
        return pHead;
    }
    if(*h != 0){
        pHead->balanceFactor += *h;
        pHead = BringBalance(pHead);
        //here is the rebalancing fonction for Phead : rebalancin(phead);
        if(pHead->balanceFactor == 0){
            *h = 0;
        }
        else{
            *h = 1;
        }
    }
    return pHead;
}


void PrintPrefix(ElecEntity* Tree){
    if(Tree==NULL){
        return ;
    }
    printf("[ElecEntity : id = %d, capacity = %d, consumption = %d, balance = %d]\n", Tree->id, Tree->capacity, Tree->consumption, Tree->balanceFactor);
    PrintPrefix(Tree->pLeft);
    PrintPrefix(Tree->pRight);
}

void FreeTree(ElecEntity* Tree){
    if(Tree!=NULL){
        FreeTree(Tree->pLeft);
        FreeTree(Tree->pRight);
        free(Tree);
    }
}

int main(){
    ElecEntity* Tree = create(1, 160000, 0, 1);
    int* h = malloc(sizeof(int));
    Tree = insert(Tree, 1, 0, 2000, 1, h);
    Tree = insert(Tree, 2, 0, 2000, 1, h);
    Tree = insert(Tree, 1, 0, 2000, 1, h);
    Tree = insert(Tree, 1, 0, 2000, 1, h);
    Tree = insert(Tree, 1, 0, 2000, 1, h);
    Tree = insert(Tree, 3, 0, 2000, 1, h);
    Tree = insert(Tree, 1, 0, 2000, 1, h);
    Tree = insert(Tree, 1, 0, 2000, 1, h);
    PrintPrefix(Tree);
    FreeTree(Tree);
    PrintPrefix(Tree);
    return 0;
}