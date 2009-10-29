$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require "devil"

Devil.with_image("#{$direc}/texture.png") do |img|
    img.pixelize(10)
    img.save("#{$direc}/texture_blocky.png")
    img.free
end

img = Devil.load_image("#{$direc}/texture.png")
bink = Devil.load_image("#{$direc}/texture.png")

img.gamma_correct(1.6)
bink.resize(50, 50)

img.save("#{$direc}/texture_gamma.png").free
bink.save("#{$direc}/texture_tiny.png").free




                   


