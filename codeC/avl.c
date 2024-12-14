#include <stdio.h>
#include <stdlib.h>

#include "structures.h"
#include "smartrobusnest.h"
#include "avl.h"

#define max(a,b) ((a)>(b) ? a : b)
#define min(a,b) ((a)<(b) ? a : b)

ElecEntity* RotateRight(ElecEntity* Tree){
    // Verification of the Tree
    if(Tree==NULL){
        exit(10);
    }
    // Verification of the left son
    if(Tree->pLeft==NULL){
        exit(11);
    }
    // Save the left son Tree adress
    ElecEntity* Pivot = Tree->pLeft;
    // Change the adress of the left son Tree, to become the right son of Pivot
    Tree->pLeft = Pivot->pRight;
    // Change the adress of the right son of Pivot, to become the adress of Tree 
    Pivot->pRight = Tree;
    // Save the balance balance of Tree
    int Balance_Tree = Tree->balanceFactor;
    // Save the balance factor of Pivot
    int Balance_Pivot = Pivot->balanceFactor;
    // Update the balance factor of Tree
    Tree->balanceFactor = Balance_Tree - min(Balance_Pivot, 0) + 1;
    // Update the balance factor of Pivot
    Pivot->balanceFactor = max(max(Balance_Tree+2, Balance_Tree + Balance_Pivot + 2), Balance_Pivot+1 );
    // Change the new adress of tree
    Tree = Pivot;
    return Tree;
}

ElecEntity* RotateLeft(ElecEntity* Tree){
    // Verification of the Tree
    if(Tree==NULL){
        exit(12);
    }
    // Verification of the right son
    if(Tree->pRight==NULL){
        exit(13);
    }
    // Save the right son Tree adress
    ElecEntity* Pivot = Tree->pRight;
    // Change the adress of the right son Tree, to become the left son of Pivot
    Tree->pRight = Pivot->pLeft;
    // Change the adress of the right son of Pivot, to become the adress of Tree
    Pivot->pLeft = Tree;
    // Save the balance balance of Tree
    int Balance_Tree = Tree->balanceFactor;
    // Save the balance factor of Pivot
    int Balance_Pivot = Pivot->balanceFactor;
    // Update the balance factor of Tree
    Tree->balanceFactor = Balance_Tree - max(Balance_Pivot, 0) - 1;
    // Update the balance factor of Pivot
    Pivot->balanceFactor = min(min(Balance_Tree-2, Balance_Tree + Balance_Pivot - 2), Balance_Pivot-1 );
    // Change the new adress of tree
    Tree = Pivot;
    return Tree;
}

ElecEntity* BringBalance(ElecEntity* Tree){
    // Verification of the tree
    if(Tree==NULL){
        return Tree;
    }
    // Make the rotation in the right side if Tree is unbalance
    if(Tree->balanceFactor>=2){
        if(Tree->pRight->balanceFactor>=0){
            //Make the left rotation
            Tree = RotateLeft(Tree);
        }
        else{
            //Make the double left rotation
            Tree->pRight = RotateRight(Tree->pRight);
            Tree = RotateLeft(Tree);
        }
    }
    // Make the rotation in the left side if Tree is unbalance
    else if(Tree->balanceFactor<=(-2)){
        //Make the right rotation
        if(Tree->pRight->balanceFactor<=0){
            Tree = RotateRight(Tree);
        }
        else{
            //Make the double right rotation
            Tree->pLeft = RotateLeft(Tree->pLeft);
            Tree = RotateRight(Tree);
        }
    }
    return Tree;
}

ElecEntity* create(int id, long capacity, long consumption){
    //Memory allocation for a new ElecEntity
    ElecEntity* new = malloc(sizeof(ElecEntity));
    //Verification if malloc is doing good work
    verifPointer(new);
    //Value assignement
    new->id = id;
    new->capacity = capacity;
    new->consumption = consumption;
    //Initialisation of the balance factor
    new->balanceFactor = 0;
    //Initialisation of left and right sons
    new->pLeft = NULL;
    new->pRight = NULL;
    return new;
}

ElecEntity* insert(ElecEntity* pHead, int id, long capacity, long consumption, int* h){
    //Creation of a new node if phead is empty
    if(pHead == NULL){
        *h = 1;
        return create(id, capacity, consumption);
    }
    //Insert a new node in the left side if the id of the new node is lower than id of a current branch
    else if(id < pHead->id){
        pHead->pLeft = insert(pHead->pLeft, id, capacity, consumption, h);
        *h = (-1)*(*h);
    }
    //Insert a new node in the right side if the id of the new node is bigger than id of a current branch
    else if(id > pHead->id){
        pHead->pRight = insert(pHead->pRight, id, capacity, consumption, h);
    }
    //If the node already exist, update the node
    else{
        *h = 0;
        pHead->consumption += consumption;
        return pHead;
    }
    if(*h != 0){
        //Update the balance after adding the new node
        pHead->balanceFactor += *h;
        //Here is the rebalancing fonction for Phead
        pHead = BringBalance(pHead);
        if(pHead->balanceFactor == 0){
            *h = 0;
        }
        else{
            *h = 1;
        }
    }
    return pHead;
}

// Print the three with a prefix process
void PrintPrefix(ElecEntity* Tree){
    if(Tree!=NULL){
        PrintPrefix(Tree->pLeft);
        printf("%d:%ld:%ld\n", Tree->id, Tree->capacity, Tree->consumption);
        PrintPrefix(Tree->pRight);
    }
}

/* Print test
void PrintPrefix2(ElecEntity* Tree){
    if(Tree==NULL){
        return ;
    }
    PrintPrefix2(Tree->pLeft);
    printf("%d;%d;%d;%d\n", Tree->id, Tree->capacity, Tree->consumption, Tree->balanceFactor);
    PrintPrefix2(Tree->pRight);
}
*/

// Freeing allocated memory for tree
void FreeTree(ElecEntity* Tree){
    if(Tree!=NULL){
        FreeTree(Tree->pLeft);
        FreeTree(Tree->pRight);
        free(Tree);
    }
}
//*
int main(){
    ElecEntity* pTree = NULL;
    int id;
    long capacity, consumption;
    int* h = malloc(sizeof(int));
    while (scanf("%d;%ld;%ld", &id, &capacity, &consumption) == 3) {
        pTree = insert(pTree, id, capacity, consumption, h);
    }
    PrintPrefix(pTree);
    FreeTree(pTree);
    free(h);
    return 0;
}
//*/

/* // Version test
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