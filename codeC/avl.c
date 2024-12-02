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
    printf("[ElecEntity : id = %d, balance = %d]\n", Tree->id, Tree->balanceFactor);
    PrintPrefix(Tree->pLeft);
    PrintPrefix(Tree->pRight);
}

Lv* createLV()

Lv* insertAVLLV(Lv* lvHead, Lv* lvNew, int h*){
    if(lvHead == NULL){
        *h = 1;
        return 
    }
}

int main(){
    ElecEntity* Tree = create(1, 200000, 177, 1);
    int* h = malloc(sizeof(int));
    Tree = insert(Tree, 2, 100000, 2000, 1, h);
    Tree = insert(Tree, 3, 100000, 2000, 1, h);
    Tree = insert(Tree, 4, 100000, 2000, 1, h);
    Tree = insert(Tree, 5, 100000, 2000, 1, h);
    Tree = insert(Tree, 6, 100000, 2000, 1, h);
    Tree = insert(Tree, 7, 100000, 2000, 1, h);
    Tree = insert(Tree, 8, 100000, 2000, 1, h);
    Tree = insert(Tree, 9, 100000, 2000, 1, h);
    int i = 10;
    while(i<1000000){
        Tree = insert(Tree, i, 100000, 2000, 1, h);
        i++;
    }
    PrintPrefix(Tree);
    return 0;
}