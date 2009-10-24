direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{direc}/../lib/")

require 'rubygems'
require "devil/gosu"

img = Devil.load_image("#{direc}/texture.png") 

img.crop(100,100, 200, 200)
img_dup = img.dup

img.rotate(rand(360))

img.show(200,200)
img_dup.show(450, 200)






                   


