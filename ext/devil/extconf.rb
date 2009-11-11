require 'mkmf'

if RUBY_PLATFORM =~ /mingw|win32/
    $CFLAGS += ' -I/home/john/.rake-compiler/ruby/ruby-1.8.6-p287/include/'
    $LDFLAGS += ' -L/home/john/.rake-compiler/ruby/ruby-1.8.6-p287/lib/'
    exit unless have_library("DevIL")
    
elsif RUBY_PLATFORM =~ /darwin/

    # this only works if you install devil via macports
    $CFLAGS += ' -I/opt/local/include/'
    $LDFLAGS += ' -L/opt/local/lib/'
    exit unless have_library("IL")

elsif RUBY_PLATFORM =~ /linux/
    exit unless have_library("IL")

end

# all platforms
exit unless have_library("ILU")

create_makefile('devil')
