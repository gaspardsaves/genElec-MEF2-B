#ifndef STRUCTURES
    #define STRUCTURES
    #include <stddef.h> 

    typedef struct post_elec {
        int id;
        int capacity;
        int consumption;
        int balanceFactor;
        struct post_elec* pLeft;
        struct post_elec* pRight;
    } ElecEntity; 

#endif