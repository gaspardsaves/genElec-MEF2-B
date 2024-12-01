#include <stdio.h>
#include <stdlib.h>
#include <avl.h>
#define max(a,b) ((a)>(b) ? a : b)
#define min(a,b) ((a)<(b) ? a : b)

int checkLV(Lv* lv){
    if(lv == NULL){
        exit(1);
    }
}

int checkHVA(HVa* hva){
    if( hva== NULL){
        exit(1);
    }
}

int checkHVB(HVb* hvb){
    if(hvb == NULL){
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

HVb* createHVB(int id, int capacity, int consCompanyHVb){
    HVb* new = malloc(sizeof(HVb));
    checkHVB(new);

    new->id = id;
    new->capacity = capacity;
    new->consCompanyHVb = consCompanyHVb;
    new->balanceFactor = 0;
    new->pLeft = NULL;
    new->pRight = NULL;

    return new;
}

HVa* createHVA(int id, int capacity, int consCompanyHVa){
    HVa* new = malloc(sizeof(HVa));
    checkHVA(new);

    new->id = id;
    new->capacity = capacity;
    new->consCompanyHVa = consCompanyHVa;
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

HVb* insertHVB(HVb* pHead, int id, int capacity, int consCompanyHVb, int* h){
    if(pHead == NULL){
        *h = 1;
        return createHVB(id, capacity, consCompanyHVb);
    }
    else if(id < pHead->id){
        pHead->pLeft = insertHVB(pHead->pLeft, id, capacity, consCompanyHVb, h);
        *h = -*h;
    }
    else if(id > pHead->id){
        pHead->pRight = insertHVB(pHead->pRight, id, capacity, consCompanyHVb, h);
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

HVa* insertHVA(HVa* pHead, int id, int capacity, int consCompanyHVa, int* h){
    if(pHead == NULL){
        *h = 1;
        return createHVA(id, capacity, consCompanyHVa);
    }
    else if(id < pHead->id){
        pHead->pLeft = insertHVA(pHead->pLeft, id, capacity, consCompanyHVa, h);
        *h = -*h;
    }
    else if(id > pHead->id){
        pHead->pRight = insertHVA(pHead->pRight, id, capacity, consCompanyHVa, h);
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

Lv* RotateRight(Lv* Tree){
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



Lv* RotateLeft(Lv* Tree){
    if(Tree==NULL){
        exit(1);
    }
    if(Tree->pLeft==NULL){
        exit(2);
    }
    int Balance_Tree = 0;
    int Balance_Pivot = 0;
    Lv* Pivot = Tree->pRight;
    Tree->pRight = Pivot->pLeft;
    Pivot->pLeft = Tree;
    Balance_Tree = Tree->balanceFactor;
    Balance_Pivot = Pivot->balanceFactor;
    Tree->balanceFactor = Balance_Tree - max(Balance_Pivot, 0) - 1;
    Pivot->balanceFactor = min(min(Balance_Tree-2, Balance_Tree + Balance_Pivot - 2), Balance_Pivot-1 );
    Tree = Pivot;
    return Tree;
}

Lv* BringBalanceLV(Lv* Tree){
    if(Tree==NULL){
        exit(4);
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
            printf("\nArbre corompu comme la France (ne le prenez pas au premier degré, c'est juste une blague)\n");
            exit(6);
        }
    }
    else if(Tree->balanceFactor<=(-2)){
        if((Tree->pLeft!=NULL)&&(Tree->pLeft->pRight)){
            Tree->pRight = RotateLeft(Tree->pRight);
            Tree = RotateRight(Tree);
        }
        else if((Tree->pLeft!=NULL)&&(Tree->pLeft->pLeft)){
            Tree = RotationLeft(Tree);
        }
        else{
            printf("\narbre corompu comme la France (ne le prenez pas au premier degré, c'est juste une blague)\n");
            exit(7);
        }
    }
    return Tree;
}


int main(){
    printf("hello");
    return 0;
}