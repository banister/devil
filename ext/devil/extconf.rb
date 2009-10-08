require 'mkmf'

$CFLAGS += ' -I/home/john/.rake-compiler/ruby/ruby-1.8.6-p287/include/'
$LDFLAGS += ' -L/home/john/.rake-compiler/ruby/ruby-1.8.6-p287/lib/'
exit unless have_library("DevIL");
exit unless have_library("ILU");
#have_library("ILUT", "ilutInit");

create_makefile('devil')
