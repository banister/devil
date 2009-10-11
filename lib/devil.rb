require 'rbconfig'

direc = File.dirname(__FILE__)
dlext = Config::CONFIG['DLEXT']
begin
    if RUBY_VERSION && RUBY_VERSION =~ /1.9/
        require "#{direc}/1.9/devil.#{dlext}"
    else
        require "#{direc}/1.8/devil.#{dlext}"
    end
rescue LoadError => e
    require "#{direc}/devil.#{dlext}"
end

# Provides a high level wrapper for the low-level DevIL Ruby bindings
module Devil
    VERSION = '0.1.5'
    
    class << self

        # loads +file+ and returns a new image
        # Optionally accepts a block and yields the newly created image to the block.
        def load_image(file, &block)
            name = IL.GenImages(1).first
            IL.BindImage(name)
            IL.LoadImage(file)

            img = Image.new(name, file)
            if block
                block.call(img)
            end
            
            img
        end

        # convert an image +blob+ with +width+ and +height
        # to a bona fide image
        def from_blob(blob, width, height)
            j = IL.FromBlob(blob, width, height)
            
            Image.new(j, nil)
        end

        # initializes Devil and sets defaults
        # This method should never need to be called directly.
        def init
            # initialize DevIL
            IL.Init

            # default options
            IL.Enable(IL::FILE_OVERWRITE)
            ILU.ImageParameter(ILU::FILTER, ILU::BILINEAR) 
        end

        alias_method :with_image, :load_image
    end

    class Image
        attr_reader :name
        
        def initialize(name, file)
            @name = name
            @file = file

            ObjectSpace.define_finalizer( self, proc { IL.DeleteImages(1, [name]) } )
        end
        
        # returns the width of the image
        def width
            set_binding
            IL.GetInteger(IL::IMAGE_WIDTH)
        end

        # returns the height of the image
        def height
            set_binding
            IL.GetInteger(IL::IMAGE_HEIGHT)
        end

        # saves the image to +file+. If no +file+ is provided default to the opened file.
        def save(file = @file)
            set_binding
            IL.SaveImage(file)
        end

        
        # resize the image to +width+ and +height+. Aspect ratios of the image do not have to be the same.
        def resize(width, height)
            set_binding
            ILU.Scale(width, height, 1)
        end

        # performs a gaussian blur on the image. The blur is performed +iter+ times.
        def blur(iter)
            set_binding
            ILU.BlurGaussian(iter)
        end

        # 'pixelize' the image using a pixel size of +pixel_size+
        def pixelize(pixel_size)
            set_binding
            ILU.Pixelize(pixel_size)
        end

        # add random noise to the image. +factor+ is the tolerance to use.
        # accepeted values range from 0.0 - 1.0
        def noisify(factor)
            set_binding
            ILU.Noisify(factor)
        end

        # The sharpening +factor+ must be in the range of 0.0 - 2.5. A value of 1.0 for the sharpening
        # factor will have no effect on the image. Values in the range 1.0 - 2.5 will sharpen the
        # image, with 2.5 having the most pronounced sharpening effect. Values from 0.0 to 1.0 do
        # a type of reverse sharpening, blurring the image. Values outside of the 0.0 - 2.5 range
        # produce undefined results.
        #        
        # The number of +iter+ (iterations) to perform will usually be 1, but to achieve more sharpening,
        # increase the number of iterations. 
        def sharpen(factor, iter)
            set_binding
            ILU.Sharpen(factor, iter)
        end

        # applies gamma correction to an image using an exponential curve.
        # +factor+ is gamma correction factor to use.
        # A value of 1.0 leaves the image unmodified.
        # Values in the range 0.0 - 1.0 darken the image
        # Values above 1.0 brighten the image.
        def gamma_correct(factor)
            set_binding
            ILU.GammaCorrect(factor)
        end

        # invert the color of every pixel in the image.
        def negative
            set_binding
            ILU.Negative
        end

        # +factor+ describes desired contrast to use
        # A value of 1.0 has no effect on the image.
        # Values between 1.0 and 1.7 increase the amount of contrast (values above 1.7 have no effect)
        # Valid range of +factor+ is 0.0 - 1.7
        def contrast(factor)
            set_binding
            ILU.Contrast(factor)
        end

        # darkens the bright colours and lightens the dark
        # colours, reducing the contrast in an image or 'equalizing' it.
        def equalize
            set_binding
            ILU.Equalize
        end

        # returns the image data in the form of a ruby string
        # The image data is formatted to RGBA / UNSIGNED BYTE
        def to_blob
            set_binding
            IL.ToBlob
        end

        # flip the image about its x axis
        def flip
            set_binding
            ILU.FlipImage
        end

        # rotate an image about its central point by +angle+ degrees
        def rotate(angle)
            set_binding
            ILU.Rotate(angle)
        end

        alias_method :columns, :width
        alias_method :rows, :height
        
        private
        
        def set_binding
            IL.BindImage(@name)
        end
        
    end
end

Devil.init
