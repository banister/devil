require 'rubygems'
require 'devil'

Devil.load_image("texture.png") do |img|
    img.negative
    img.save("texture_neg.png")
end

img = Devil.load_image("texture.png")
bink = Devil.load_image("texture.png")
img.blur(4)
bink.resize(50, 50)
img.save("texture_blur.png")
bink.save("texture_tiny.png")


    


