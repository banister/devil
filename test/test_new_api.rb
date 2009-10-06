require 'rubygems'
require 'devil'

IL.LoadImage("texture.png")

img = Devil.load_image("texture.png")

img.resize(45, 36)

img.save("texture_tiny.jpg")
