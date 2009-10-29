require 'rubygems'
require 'devil'

def memory
    `ps -o vsz,rss -p #{$$}`.strip.split
end

class Blah
    def initialize
        ObjectSpace.define_finalizer(self, proc { puts "cleaned up!!!"} )
        @x = "\0"*10000
    end
end

p memory
10.times do
    1_000.times do
        Blah.new
    end
    GC.start
    p Process.times
    p memory
end
