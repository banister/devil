require 'mkmf'

if RUBY_PLATFORM =~ /mingw|win32/
    $CFLAGS += ' -I/home/john/.rake-compiler/ruby/ruby-1.8.6-p287/include/'
    $LDFLAGS += ' -L/home/john/.rake-compiler/ruby/ruby-1.8.6-p287/lib/'
    exit unless have_library("freeglut_static") 
    exit unless have_library("opengl32")
    exit unless have_library("DevIL")
    
elsif RUBY_PLATFORM =~ /darwin/

    # this only works if you install devil via macports
    $CFLAGS += ' -I/opt/local/include/ -I/System/Library/Frameworks/GLUT.framework/Headers'
    $LDFLAGS += ' -L/opt/local/lib/ -framework GLUT'
    exit unless have_library("IL")

elsif RUBY_PLATFORM =~ /linux/
    exit unless have_library("IL")

    exit unless have_library("glut")
    exit unless have_library("GL")
end

# all platforms
exit unless have_library("ILU")
exit unless have_library("ILUT")

create_makefile('devil')
