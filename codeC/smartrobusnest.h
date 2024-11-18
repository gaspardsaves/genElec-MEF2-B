#ifndef VERIF
    #define VERIF
    #include <stddef.h>
    
    void verifpointer(void* p);
    //void checkOpenFile(FILE* f);
    void checkWritingFile(int writeReturn);
    void checkCloseFile(int closeReturn);
    int better_scan(char * message);
    float better_scanFloat(char * message);
    unsigned better_scanUn(char * message);
#endif