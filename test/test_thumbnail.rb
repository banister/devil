$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.load("texture.png") do |img|
    img.dup.thumbnail2(100, :filter => Devil::NEAREST, :gauss => 4).show(200, 300).free
    img.dup.thumbnail2(100, :filter => Devil::NEAREST, :gauss => 1).show(500, 300).free
    img.dup.thumbnail(100).save("thumb.png").show(200, 500).free
end

