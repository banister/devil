$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

Devil.load("texture.png", :inprofile => "sRGB.icm", :out_profile => "AdobeRGB1998.icc").save("texture_out.png").free
