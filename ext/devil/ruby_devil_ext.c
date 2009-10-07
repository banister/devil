#include "ruby_devil_ext.h"


void
Init_devil() {
    InitializeIL();
    InitializeILU();

    /* turning off ILUT layer */
    /*    InitializeILUT(); */
}
