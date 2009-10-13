$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'gosu'
require 'devil'

class W < Gosu::Window
    def initialize
        super(1024, 768, false, 20)

        img = Devil.load_image("#{$direc}/texture.jpg")

        @img = Gosu::Image.new(self, img)
    end
    
    def draw
        @img.draw 100, 50,1
    end
    
end

w = W.new
w.show
        
