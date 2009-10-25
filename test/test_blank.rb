$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.set_options :load_image_hook => proc { IL.ConvertImage(IL::RGBA, IL::UNSIGNED_BYTE) }

Devil.create_image(500, 500, :color => [255, 255, 0, 255]) do |img|
    source1 = Devil.load("texture.png").thumbnail(100)
    img.blit source1, 100, 100
    img.blit source1, 400, 100
    img.blit source1.dup.rotate(45), 100, 300
    img.show
end

