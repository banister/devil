$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.load("texture.png") do |img|
    img.dup.thumbnail(150, :filter => Devil::NEAREST).show(100, 300)
    img.dup.thumbnail(150).show(100, 100)
end

