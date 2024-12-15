#ifndef COLORS
  #define COLORS
  #include <stdio.h>
  #define clrscr() printf("\033[H\033[2J")
  #define color(param) printf("\033[%sm",param)
#endif