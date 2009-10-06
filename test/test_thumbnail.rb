require 'rubygems'
require 'devil'

IL.Init

name = IL.GenImages(1)[0]
IL.BindImage(name)
IL.LoadImage("texture.png")

puts "image height/width"
puts IL.GetInteger(IL::IMAGE_WIDTH)
puts IL.GetInteger(IL::IMAGE_HEIGHT)

ILU.Scale(100, 100, 1)

IL.Enable(IL::FILE_OVERWRITE)

IL.SaveImage("desert_thumb.png")


