direc = File.dirname(__FILE__)

require 'rubygems'
require "#{direc}/../lib/devil"


Devil.load_image("#{direc}/texture.png") do |img|
    img.negative
    img.save("#{direc}/texture_neg.png")
end

img = Devil.load_image("#{direc}/texture.png")
bink = Devil.load_image("#{direc}/texture.png")

img.blur(4)
bink.resize(50, 50)

img.save("#{direc}/texture_blur.png")
bink.save("#{direc}/texture_tiny.png")


                   


