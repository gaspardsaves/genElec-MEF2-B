#include <stdlib.h>
#include <avl.h>
#define max(a,b) ((a)>(b) ? a : b)
#define min(a,b) ((a)<(b) ? a : b)

int checkLV(Lv* lv){
    if(lv == NULL){
        exit(1);
    }
}

Lv* createLV(int id, int capacity, int consAll, int consCompanyLv, int consHouseHold){
    Lv* new = malloc(sizeof(Lv));
    checkLV(new);

    new->id = id;
    new->capacity = capacity;
    new->consAll = consAll;
    new->consCompanyLv = consCompanyLv;
    new->consHouseHold = consHouseHold;
    new->balanceFactor = 0;
    new->pLeft = NULL;
    new->pRight = NULL;

    return new;
}

Lv* insertLV(Lv* pHead, int id, int capacity, int consAll, int consCompanyLv, int consHouseHold, int* h){
    if(pHead == NULL){
        *h = 1;
        return createLV(id, capacity, consAll, consCompanyLv, consHouseHold);
    }
    else if(id < pHead->id){
        pHead->pLeft = insertLV(pHead->pLeft, id, capacity, consAll, consCompanyLv, consHouseHold, h);
        *h = -*h;
    }
    else if(id > pHead->id){
        pHead->pRight = insertLV(pHead->pRight, id, capacity, consAll, consCompanyLv, consHouseHold, h);
    }
    else{
        *h = 0;
        return pHead;
    }

    if(*h != 0){
        pHead->balanceFactor += *h;
        //here is the rebalancing fonction for Phead : rebalancingLV(phead);
        if(pHead->balanceFactor == 0){
            *h = 0;
        }
        else{
            *h = 1;
        }
    }
    return pHead;
}

void* RotateRight(Lv* Tree){
    if(Tree==NULL){
        exit(1);
    }
    if(Tree->pLeft==NULL){
        exit(2);
    }
    int Balance_Tree = 0;
    int Balance_Pivot = 0;
    Lv* Pivot = Tree->pLeft;
    Tree->pLeft = Pivot->pRight;
    Pivot->pRight = Tree;
    Balance_Tree = Tree->balanceFactor;
    Balance_Pivot = Pivot->balanceFactor;
    Tree->balanceFactor = Balance_Tree - min(Balance_Pivot, 0) + 1;
    Pivot->balanceFactor = max(max(Balance_Tree+2, Balance_Tree + Balance_Pivot + 2), Balance_Pivot+1 );
    Tree = Pivot;
    return Tree;
}


int main(){
    return 0;
}