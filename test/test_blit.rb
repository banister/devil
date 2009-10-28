$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.with_image("#{$direc}/texture.png") do |img|
    img2 = Devil.load("#{$direc}/red.png")
    img2.free

    img.show(200,200)

    img.blit img2, 100, 100, :crop => [0, 0, img2.width / 2, img2.height / 2]

    img.show
end



                   


