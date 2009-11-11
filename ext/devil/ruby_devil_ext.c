#include "ruby_devil_ext.h"


void
Init_devil() {
    InitializeIL();
    InitializeILU();
    /* InitializeILUT(); */
}
