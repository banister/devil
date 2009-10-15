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
    VERSION = '0.1.6'
    
    class << self

        # loads +file+ and returns a new image
        # Optionally accepts a block and yields the newly created image to the block.
        def load_image(file, &block)
            name = IL.GenImages(1).first
            IL.BindImage(name)
            IL.LoadImage(file)

            if (error_code = IL.GetError) != IL::NO_ERROR
                raise RuntimeError, "an error occured while trying to "+
                    "load the image #{file}. Error code: #{error_code}"
            end

            img = Image.new(name, file)
            if block
                block.call(img)
            end
            
            img
        end

        alias_method :with_image, :load_image
        alias_method :load, :load_image

        # convert an image +blob+ with +width+ and +height+
        # to a bona fide image
        def from_blob(blob, width, height)
            Image.new(IL.FromBlob(blob, width, height), nil)
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

    end

    class Image
        attr_reader :name, :file

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

        alias_method :columns, :width

        # returns the height of the image
        def height
            set_binding
            IL.GetInteger(IL::IMAGE_HEIGHT)
        end

        alias_method :rows, :height

        # saves the image to +file+. If no +file+ is provided default to the opened file.
        def save(file = @file)
            set_binding
            IL.SaveImage(file)
            self
        end
        
        # resize the image to +width+ and +height+. Aspect ratios of the image do not have to be the same.
        def resize(width, height)
            set_binding
            ILU.Scale(width, height, 1)
            self
        end

        # Creates a proportional thumbnail of the image scaled so its longest
        # edge is resized to +size+ 
        def thumbnail(size)
            # this thumbnail code from image_science.rb
            
            w, h = width, height
            scale = size.to_f / (w > h ? w : h)
            resize((w * scale).to_i, (h * scale).to_i)
            self
        end

        # return a deep copy of the current image
        def dup
            set_binding
            Image.new(IL.CloneCurImage, nil)
        end

        alias_method :clone, :dup

        # crop the current image
        # +xoff+ number of pixels to skip in x direction
        # +yoff+ number of pixels to skip in y direction
        # +width+ number of pixels to preserve in x direction
        # +height+ number of pixels to preserve in y direction
        def crop(xoff, yoff, width, height)
            set_binding
            ILU.Crop(xoff, yoff, width, height)
            self
        end

        # performs a gaussian blur on the image. The blur is performed +iter+ times.
        def blur(iter)
            set_binding
            ILU.BlurGaussian(iter)
            self
        end

        # 'pixelize' the image using a pixel size of +pixel_size+
        def pixelize(pixel_size)
            set_binding
            ILU.Pixelize(pixel_size)
            self
        end

        # add random noise to the image. +factor+ is the tolerance to use.
        # accepeted values range from 0.0 - 1.0
        def noisify(factor)
            set_binding
            ILU.Noisify(factor)
            self
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
            self
        end

        # applies gamma correction to an image using an exponential curve.
        # +factor+ is gamma correction factor to use.
        # A value of 1.0 leaves the image unmodified.
        # Values in the range 0.0 - 1.0 darken the image
        # Values above 1.0 brighten the image.
        def gamma_correct(factor)
            set_binding
            ILU.GammaCorrect(factor)
            self
        end

        # invert the color of every pixel in the image.
        def negative
            set_binding
            ILU.Negative
            self
        end

        # +factor+ describes desired contrast to use
        # A value of 1.0 has no effect on the image.
        # Values between 1.0 and 1.7 increase the amount of contrast (values above 1.7 have no effect)
        # Valid range of +factor+ is 0.0 - 1.7
        def contrast(factor)
            set_binding
            ILU.Contrast(factor)
            self
        end

        # darkens the bright colours and lightens the dark
        # colours, reducing the contrast in an image or 'equalizing' it.
        def equalize
            set_binding
            ILU.Equalize
            self
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
            self
        end

        # rotate an image about its central point by +angle+ degrees
        def rotate(angle)
            set_binding
            ILU.Rotate(angle)
            self
        end

        private
        
        def set_binding
            IL.BindImage(@name)
        end

    end
end

Devil.init
