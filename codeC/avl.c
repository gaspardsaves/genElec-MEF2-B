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

Lv* InsertLV(Lv* pHead, int id, int capacity, int consAll, int consCompanyLv, int consHouseHold, int* h){
    if(pHead == NULL){
        *h = 1;
        return createLV(id, capacity, consAll, consCompanyLv, consHouseHold);
    }
    else if(id < pHead->id){
        pHead->pLeft = InsertLV(pHead->pLeft, id, capacity, consAll, consCompanyLv, consHouseHold, h);
        *h = -*h;
    }
    else if(id > pHead->id){
        pHead->pRight = InsertLV(pHead->pRight, id, capacity, consAll, consCompanyLv, consHouseHold, h);
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
}


int main(){
    return 0;
}