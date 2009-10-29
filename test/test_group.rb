$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.with_group("#{$direc}/texture.png", "#{$direc}/red.png") do |img, img2|

    img.blit img2, 100, 100, :crop => [0, 0, img2.width / 2, img2.height / 2]
    img.show
end



                   


