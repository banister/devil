$direc = File.dirname(__FILE__)
$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil'

def memory
    `ps -o vsz,rss -p #{$$}`.strip.split
end

p memory
10.times do
    1_00.times do
        im = Devil.with_group("red.png", "texture.jpg") { }
    end
    GC.start
    p Process.times
    p memory
end
