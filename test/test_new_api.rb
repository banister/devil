require 'rubygems'
require 'devil'

img = Devil.load_image("texture.png")

img.resize(45, 36)

img.save("texture_tiny.jpg")
