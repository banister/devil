$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require "devil"

Devil.with_image("#{$direc}/texture.png") do |img|
    img.negative
    img.save("#{$direc}/texture_neg.png")
end

img = Devil.load_image("#{$direc}/texture.png")
bink = Devil.load_image("#{$direc}/texture.png")

img.gamma_correct(1.6)
bink.resize(50, 50)

img.save("#{$direc}/texture_gamma.png")
bink.save("#{$direc}/texture_tiny.png")


                   


