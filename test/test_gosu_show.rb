$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.load_image("texture.png").emboss.show(512, 400)
Devil.load_image("tank.png").show(300, 400)

