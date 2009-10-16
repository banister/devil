require 'mkmf'

if RUBY_PLATFORM =~ /mingw/
    $CFLAGS += ' -I/home/john/.rake-compiler/ruby/ruby-1.8.6-p287/include/'
    $LDFLAGS += ' -L/home/john/.rake-compiler/ruby/ruby-1.8.6-p287/lib/'
elsif RUBY_PLATFORM =~ /darwin/

    # this only works if you install devil via macports
    $CFLAGS += ' -I/opt/local/include/'
    $LDFLAGS += ' -L/opt/local/lib/'
end

if RUBY_PLATFORM =~ /(win32|mingw)/
    exit unless have_library("DevIL");
else
    exit unless have_library("IL");
end

exit unless have_library("ILU");

#have_library("ILUT", "ilutInit");

create_makefile('devil')
