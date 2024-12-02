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
        if((Tree->pRight!=NULL)&&(Tree->pRight->pLeft!=NULL)){
            Tree->pRight = RotateRight(Tree->pRight);
            Tree = RotateLeft(Tree);
        }
        else if((Tree->pRight!=NULL)&&(Tree->pRight->pRight!=NULL)){
            Tree = RotateLeft(Tree);
        }
        else{
            printf("\nArbre corompu\n");
            exit(6);
        }
    }
    else if(Tree->balanceFactor<=(-2)){
        if((Tree->pLeft!=NULL)&&(Tree->pLeft->pRight)){
            Tree->pLeft = RotateLeft(Tree->pLeft);
            Tree = RotateRight(Tree);
        }
        else if((Tree->pLeft!=NULL)&&(Tree->pLeft->pLeft)){
            Tree = RotateRight(Tree);
        }
        else{
            printf("\narbre corompu\n");
            exit(7);
        }
    }
    return Tree;
}

int check(ElecEntity* Tree){
    if (Tree == NULL){
        exit(1);
    }
}

ElecEntity* create(int id, int capacity, int consumption){
    ElecEntity* new = malloc(sizeof(ElecEntity));
    check(new);

    new->id = id;
    new->capacity = capacity;
    new->consumption = consumption;
    new->balanceFactor = 0;
    new->pLeft = NULL;
    new->pRight = NULL;

    return new;
}

ElecEntity* insert(ElecEntity* pHead, int id, int capacity, int consumption, int* h){
    if(pHead == NULL){
        *h = 1;
        return create(id, capacity, consumption);
    }
    else if(id < pHead->id){
        pHead->pLeft = insert(pHead->pLeft, id, capacity, consumption, h);
        *h = -*h;
    }
    else if(id > pHead->id){
        pHead->pRight = insert(pHead->pRight, id, capacity, consumption, h);
    }
    else{
        *h = 0;
        return pHead;
    }
    if(*h != 0){
        pHead->balanceFactor += *h;
        //here is the rebalancing fonction for Phead : rebalancin(phead);
        if(pHead->balanceFactor == 0){
            *h = 0;
        }
        else{
            *h = 1;
        }
    }
    pHead = BringBalance(pHead);
    return pHead;
}


void PrintPrefix(ElecEntity* Tree){
    if(Tree==NULL){
        return ;
    }
    printf(" : id = %d, balance = %d]\n", Tree->id, Tree->balanceFactor);
    PrintPrefix(Tree->pLeft);
    PrintPrefix(Tree->pRight);
}

int main(){
    ElecEntity* Tree = create(1, 200000, 177);
    int* h = malloc(sizeof(int));
    Tree = insert(Tree, 2, 100000, 2000, h);
    Tree = insert(Tree, 3, 100000, 2000, h);
    PrintPrefix(Tree);
    return 0;
}