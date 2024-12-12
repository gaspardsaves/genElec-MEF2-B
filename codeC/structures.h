#ifndef STRUCTURES
    #define STRUCTURES
    #include <stddef.h> 

    typedef struct post_elec {
        int id;
        int balanceFactor;
        long capacity;
        long consumption;
        struct post_elec* pLeft;
        struct post_elec* pRight;
    } ElecEntity; 

#endif