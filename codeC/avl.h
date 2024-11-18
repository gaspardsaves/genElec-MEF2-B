#ifndef VERIF
    #define VERIF
    #include <stddef.h> 
    typedef struct _consumer {
        int id;
        int load;
        struct _consumer* Left;
        struct _consumer* Right;
    }Consumer;

    typedef struct {
        int id;
        int capacity;
        Consumer* consumerHead;
    }LvPost;

    typedef struct {
        int id;
        int capacity;
        LvPost* LvTab;
        Consumer* consumerHead;
    }HV_A;

    typedef struct {
        int id;
        int capacity;
        HV_A* tab;
        Consumer* consumerHead;
    }HV_B;

    typedef struct {
        int id;
        int capacity;
        HV_B* tab;
        Consumer* consumerHead;
    }PowerPlant;
#endif