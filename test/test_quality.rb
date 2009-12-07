$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.load("texture.png").save("texture_out1.jpg", :quality => 50).
    save("texture_out2.jpg").free
