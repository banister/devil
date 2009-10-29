$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

class W < Gosu::Window
    def initialize
        super(1024, 768, false, 20)

        @img = Gosu::Image.new(self, "#{$direc}/texture.jpg")
        dimg = @img.to_devil
        @img = dimg.emboss.
            rotate(45).
            to_gosu(self)
        
        dimg.free
    end
    
    def draw
        @img.draw 100, 50,1
    end
    
end

w = W.new
w.show

