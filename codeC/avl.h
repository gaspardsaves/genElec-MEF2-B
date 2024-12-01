#ifndef AVL_H
    #define AVL_H
    #include "structures.h"

    int checkLV(Lv* lv);
    int checkHVA(HVa* hva);
    int checkHVB(HVb* hvb);
    Lv* createLV(int id, int capacity, int consAll, int consCompanyLv, int consHouseHold);
    HVb* createHVB(int id, int capacity, int consCompanyHVb);
    HVa* createHVA(int id, int capacity, int consCompanyHVa);
    Lv* insertLV(Lv* pHead, int id, int capacity, int consAll, int consCompanyLv, int consHouseHold, int* h);
    HVb* insertHVB(HVb* pHead, int id, int capacity, int consCompanyHVb, int* h);
    HVa* insertHVA(HVa* pHead, int id, int capacity, int consCompanyHVa, int* h);
    Lv* RotateRight(Lv* Tree);
    Lv* RotateLeft(Lv* Tree);
    Lv* BringBalanceLV(Lv* Tree);
    int main();

#endif