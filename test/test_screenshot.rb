$direc = File.dirname(__FILE__)

$LOAD_PATH.push("#{$direc}/../lib/")

require 'rubygems'
require 'devil/gosu'

class W < Gosu::Window
    def initialize
        super(1024, 768, false, 20)

        @img = Gosu::Image.new(self, "tank.png")
        @img2 = @img.dup
        @img.circle 100, 100, 50, :color => :purple, :filled => true
        @img2.splice_and_scale @img2, 100, 100, :factor => 0.2

        @img.save("tank-modified.png")
    end
    
    def draw
        @img.draw 100, 50,1
        @img.draw 300, 50, 1
        @img2.draw 300, 400, 1
    end

    def update
        if button_down?(Gosu::KbEscape)
            screenshot.rotate(45).save("screenshot.png")
            exit
        end
    end
end

w = W.new
w.show
        
