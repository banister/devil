$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'opengl'
require 'devil/gosu'


class W < Gosu::Window
    def initialize
        super(1024, 768, false, 20)

        @img = Gosu::Image.new(self, "tank.png")

        @img.save("horse.png")
    end
    
    def draw
        @img.draw 100, 50,1
        @img.draw 500, 50,1
        save_screenshot("plunket.png")
    end
    
end


w = W.new
w.show
        
