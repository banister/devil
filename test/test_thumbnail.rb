$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.load("texture.png") do |img|
    #img.thumbnail(150)
    img.show
    ILU.ImageParameter(ILU::FILTER, ILU::NEAREST)
    bspline = img.dup
    bspline.thumbnail(150)
    bspline.show(800,300)
end

