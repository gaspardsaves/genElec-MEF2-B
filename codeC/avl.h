#ifndef VERIF
    #define VERIF
    #include <stddef.h> 

    typedef struct lv_post {
        int id;
        int capacity;
        int consAll;
        int consCompanyLv;
        int consHouseHold;
        int balanceFactor;
        struct lv_post* pLeft;
        struct lv_post* pRight;
    }Lv;

    typedef struct hv_a {
        int id;
        int capacity;
        int consCompanyHVa;
        int balanceFactor;
        struct hv_a* pLeft;
        struct hv_a* pRight;
    }HVa;

    typedef struct hv_b {
        int id;
        int capacity;
        int consCompanyHVb;
        int balanceFactor;
        struct hv_b* pLeft;
        struct hv_b* pRight;
    }HVb

#endif