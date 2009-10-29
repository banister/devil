# (C) John Mair 2009, under the MIT licence

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
    include IL
    include ILU

    VERSION = '0.1.8.8'
    
    class << self

        # loads +file+ and returns a new image
        # Optionally accepts a block and yields the newly created image to the block.
        def load_image(file, options={}, &block)
            name = prepare_image
            attach_image_from_file(file)
            
            out_profile = options[:out_profile]
            in_profile = options[:in_profile]
            
            # apply a color profile if one is provided
            IL.ApplyProfile(in_profile, out_profile) if out_profile

            check_and_run_hook(:load_image_hook)
            error_check
            wrap_and_yield(name, file, block)
        end

        alias_method :with_image, :load_image
        alias_method :load, :load_image

        # returns a blank image of +width+ and +height+.
        # Optionally accepts the :color hash param that fills the new image with a color
        # (see: Devil.set_options :clear_color)
        # Optionally accepts a block and yields the newly created image to the block.
        def create_image(width, height, options={}, &block)
            name = prepare_image
            out_profile = options[:out_profile]
            in_profile = options[:in_profile]

            clear_color = options[:color]

            # created image is formatted RGBA8
            IL.TexImage(width, height, 1, 4, IL::RGBA, IL::UNSIGNED_BYTE, nil)

            # apply a color profile if one is provided
            IL.ApplyProfile(in_profile, out_profile) if out_profile            

            IL.ClearColour(*clear_color) if clear_color
            IL.ClearImage
            IL.ClearColour(*Devil.get_options[:clear_color]) if clear_color

            check_and_run_hook(:create_image_hook)
            error_check
            wrap_and_yield(name, nil, block)
        end

        alias_method :create_blank_image, :create_image

        # load multiple images and yield them to the block
        # e.g Devil.with_group("hello.png", "friend.png") { |img1, img2| ... }
        # all yielded images are cleaned up at end of block so you do not need to
        # explictly call img1.free
        def with_group(*files, &block)
            images = files.map do |file|
                name = prepare_image
                attach_image_from_file(file)
                check_and_run_hook(:load_image_hook)
                error_check
                
                Image.new(name, file)
            end

            if block
                begin
                    block.call(*images)
                ensure
                    images.each { |img| img.free if img.name }
                end
            else
                raise RuntimeError, "a block must be provided."
            end
        end

        alias_method :with_images, :with_group
        
        # convert an image +blob+ with +width+ and +height+
        # to a bona fide image
        def from_blob(blob, width, height)
            Image.new(IL.FromBlob(blob, width, height), nil)
        end

        # configure Devil.
        # accepts hash parameters: :scale_filter, :placement, :clear_color,
        # :window_size, :edge_filter.
        #
        # :scale_filter accepts a valid scaling algorithm: (default is LANCZOS3).
        # Devil::NEAREST, Devil::LINEAR, Devil::BILINEAR, Devil::SCALE_BOX,
        # Devil::SCALE_TRIANGLE, Devil::SCALE_BELL, Devil::SCALE_BSPLINE,
        # Devil::SCALE_LANCZOS3, Devil::SCALE_MITCHELL
        #
        # :placement determines where in the canvas the image will be placed after
        # the canvas has been enlarged using the 'enlarge_canvas' method.
        # Valid parameters are: Devil::CENTER, Devil::LOWER_LEFT, Devil::UPPER_RIGHT, etc
        #
        # :clear_color  sets the current clearing colour to be used by future
        # calls to clear. rotate and enlarge_canvas both use these values to
        # clear blank space in images, too.
        # e.g Devil.set_options(:clear_color => [255, 255, 0, 255])
        # Above sets the clear color to yellow with full opacity.
        #
        # :window_size sets the display window size Gosu will use when displaying images
        # that invoked the 'show' method. (default is 1024 x 768)
        # e.g Devil.set_options(:window_size => [2000, 768])
        # Example above sets a window size of 2000x768.
        # Note: :window_size is only relevant when require 'devil/gosu' is used.
        #
        # :edge_filter sets the edge detection algorithm to use when invoking
        # the 'edge_detect' method. (defaults to :prewitt)
        # Allowed values are :prewitt and :sobel
        #
        # hooks:
        # :prepare_image_hook, :create_image_hook, :load_image_hook
        # e.g Devil.set_options :load_image_hook => proc { IL::ConvertImage(IL::RGBA, IL::UNSIGNED_BYTE) }
        def set_options(options={})
            @options.merge!(options)

            # update the config. options 
            ILU.ImageParameter(ILU::FILTER, @options[:scale_filter])
            ILU.ImageParameter(ILU::PLACEMENT, @options[:placement])
            IL.ClearColour(*@options[:clear_color])
        end

        # return the current Devil configuration.
        def get_options
            @options
        end

        # initializes Devil and sets defaults.
        # This method should never need to be called directly.
        def init
            # initialize DevIL
            IL.Init
            ILU.Init

            set_defaults
        end

        # restore Devil's default configuration.
        def set_defaults
            @options = {
                :scale_filter => ILU::SCALE_LANCZOS3,
                :edge_filter => :prewitt,
                :window_size => [1024, 768],
                :clear_color => [255, 248, 230, 0],
                :placement => ILU::CENTER,
                :prepare_image_hook => nil,
                :load_image_hook => nil,
                :create_image_hook => nil,
            }
            
            # configurable options
            ILU.ImageParameter(ILU::FILTER, @options[:scale_filter])
            ILU.ImageParameter(ILU::PLACEMENT, @options[:placement])
            IL.ClearColour(*@options[:clear_color])

            # fixed options
            IL.Enable(IL::FILE_OVERWRITE)
            IL.Enable(IL::ORIGIN_SET)
            IL.OriginFunc(IL::ORIGIN_LOWER_LEFT)
        end

        alias_method :restore_defaults, :set_defaults

        private

        def prepare_image
            name = IL.GenImages(1).first
            IL.BindImage(name)

            check_and_run_hook(:prepare_image_hook)

            name
        end

        def attach_image_from_file(file)
            IL.LoadImage(file)

            # ensure all images are formatted RGBA8
            IL.ConvertImage(IL::RGBA, IL::UNSIGNED_BYTE)
        end

        def wrap_and_yield(name, file, block)
            img = Image.new(name, file)
            if block
                begin
                    block.call(img)
                ensure
                    img.free if img.name
                end
            else
                img
            end            
        end

        def check_and_run_hook(hook_name)
            Devil.get_options[hook_name].call if Devil.get_options[hook_name]
        end

        def error_check
            if (error_code = IL.GetError) != IL::NO_ERROR
                raise RuntimeError, "An error occured. #{ILU.ErrorString(error_code)}"
            end
        end
    end
end
## end of Devil module 

# wraps a DevIL image
class Devil::Image
    attr_reader :name, :file

    def initialize(name, file)
        @name = name
        @file = file
    end

    # Frees the memory associated with the image.
    # Must be called explictly if load_image or create_image is invoked without a block.
    def free
        raise "Error: calling 'free' on already freed image! #{self}" if !@name
        IL.DeleteImages([@name])
        error_check
        @name = nil
    end

    alias_method :close, :free
    alias_method :delete, :free
    
    # returns the width of the image.
    def width
        action { IL.GetInteger(IL::IMAGE_WIDTH) }
    end

    alias_method :columns, :width

    # returns the height of the image.
    def height
        action { IL.GetInteger(IL::IMAGE_HEIGHT) }
    end

    alias_method :rows, :height

    # saves the image to +file+. If no +file+ is provided default to the opened file.
    def save(file = @file)
        raise "This image does not have an associated file. Please provide an explicit file name when saving." if !file
        
        action { IL.SaveImage(file) }
        self
    end
    
    # resize the image to +width+ and +height+. Aspect ratios of the image do not have to be the same.
    # Optional :filter hash parameter that maps to a valid scale filter
    # (see: Devil.set_options :scale_filter)
    def resize(width, height, options = {})
        filter = options[:filter]

        action do
            ILU.ImageParameter(ILU::FILTER, filter) if filter
            ILU.Scale(width, height, 1)
            ILU.ImageParameter(ILU::FILTER, Devil.get_options[:scale_filter]) if filter
        end
        
        self
    end

    # Creates a proportional thumbnail of the image scaled so its longest
    # edge is resized to +size+.
    # Optional :filter hash parameter that maps to a valid scale filter
    # (see: Devil.set_options :scale_filter)
    def thumbnail(size, options = {})

        # this thumbnail code from image_science.rb
        w, h = width, height
        scale = size.to_f / (w > h ? w : h)
        resize((w * scale).to_i, (h * scale).to_i, options)
        self
    end

    # return a deep copy of the current image.
    def dup
        new_image_name = action { IL.CloneCurImage }
        Devil::Image.new(new_image_name, nil)
    end

    alias_method :clone, :dup

    # crop the current image.
    # +xoff+ number of pixels to skip in x direction.
    # +yoff+ number of pixels to skip in y direction.
    # +width+ number of pixels to preserve in x direction.
    # +height+ number of pixels to preserve in y direction.
    def crop(xoff, yoff, width, height)
        action { ILU.Crop(xoff, yoff, 1, width, height, 1) }
        self
    end

    # enlarge the canvas of current image to +width+ and +height+.
    def enlarge_canvas(width, height)
        if width < self.width || height < self.height
            raise "width and height parameters must be larger than current image width and height"
        end
        
        action { ILU.EnlargeCanvas(width, height, 1) }
        self
    end

    # splice the +source+ image into current image at position +x+ and +y+.
    # Takes an optional +:crop+ hash parameter that has the following format: +:crop => [sx, sy, width, height]+
    # +sx+, +sy+, +width, +height+ crop the source image to be spliced.
    # +sx+ is how many pixels to skip in x direction of source image.
    # +sy+ is how many pixels to skip in y direction of source image.
    # +width+ number of pixels to preserve in x direction of source image.
    # +height+ number of pixels to preserve in y direction of source image.
    # if no +:crop+ parameter is provided then the whole image is spliced in.
    def blit(source, x, y, options = {})
        options = {
            :crop => [0, 0, source.width, source.height]
        }.merge!(options)
        
        action do
            IL.Blit(source.name, x, y, 0, options[:crop][0], options[:crop][1], 0,
                    options[:crop][2], options[:crop][3], 1)
        end
        
        self
    end

    alias_method :composite, :blit

    # reflect image about its y axis.
    def mirror
        action { ILU.Mirror }
        self
    end

    # use prewitt or sobel filters to detect the edges in the current image.
    # Optional :filter hash parameter selects filter to use (:prewitt or :sobel).
    # (see: Devil.set_options :edge_filter)    
    def edge_detect(options={})
        options = {
            :filter => Devil.get_options[:edge_filter]
        }.merge!(options)
        
        case options[:filter]
        when :prewitt
            action { ILU.EdgeDetectP }
        when :sobel
            action { ILU.EdgeDetectS }
        else
            raise "No such edge filter #{options[:filter]}. Use :prewitt or :sobel"
        end
        self
    end

    # embosses an image, causing it to have a "relief" feel to it using a convolution filter.
    def emboss
        action { ILU.Emboss }
        self
    end

    # applies a strange color distortion effect to the image giving  a preternatural feel
    def alienify
        action { ILU.Alienify }
        self
    end

    # performs a gaussian blur on the image. The blur is performed +iter+ times.
    def blur(iter)
        action { ILU.BlurGaussian(iter) }
        self
    end

    # 'pixelize' the image using a pixel size of +pixel_size+.
    def pixelize(pixel_size)
        action { ILU.Pixelize(pixel_size) }
        self
    end

    # add random noise to the image. +factor+ is the tolerance to use.
    # accepeted values range from 0.0 - 1.0.
    def noisify(factor)
        action { ILU.Noisify(factor) }
        self
    end

    # The sharpening +factor+ must be in the range of 0.0 - 2.5. A value of 1.0 for the sharpening.
    # factor will have no effect on the image. Values in the range 1.0 - 2.5 will sharpen the
    # image, with 2.5 having the most pronounced sharpening effect. Values from 0.0 to 1.0 do
    # a type of reverse sharpening, blurring the image. Values outside of the 0.0 - 2.5 range
    # produce undefined results.
    #        
    # The number of +iter+ (iterations) to perform will usually be 1, but to achieve more sharpening,
    # increase the number of iterations. 
    def sharpen(factor, iter)
        action { ILU.Sharpen(factor, iter) }
        self
    end

    # applies gamma correction to an image using an exponential curve.
    # +factor+ is gamma correction factor to use.
    # A value of 1.0 leaves the image unmodified.
    # Values in the range 0.0 - 1.0 darken the image
    # Values above 1.0 brighten the image.
    def gamma_correct(factor)
        action { ILU.GammaCorrect(factor) }
        self
    end

    # invert the color of every pixel in the image.
    def negate
        action { ILU.Negative }
        self
    end

    alias_method :negative, :negate

    # +factor+ describes desired contrast to use
    # A value of 1.0 has no effect on the image.
    # Values between 1.0 and 1.7 increase the amount of contrast (values above 1.7 have no effect)
    # Valid range of +factor+ is 0.0 - 1.7.
    def contrast(factor)
        action { ILU.Contrast(factor) }
        self
    end

    # darkens the bright colours and lightens the dark
    # colours, reducing the contrast in an image or 'equalizing' it.
    def equalize
        action { ILU.Equalize }
        self
    end

    # returns the image data in the form of a ruby string.
    # The image data is formatted to RGBA / UNSIGNED BYTE.
    def to_blob
        action { IL.ToBlob }
    end

    # flip the image about its x axis.
    def flip
        action { ILU.FlipImage }
        self
    end

    # rotate an image about its central point by +angle+ degrees (counter clockwise).
    def rotate(angle)
        action { ILU.Rotate(angle) }
        self
    end

    #  simply clears the image to the 'clear color' (specified using Devil.set_options(:clear_color => [r, g, b, a])
    def clear
        action { IL.ClearImage }
        self
    end

    private

    def set_binding
        raise "Error: trying to use image that has already been freed! #{self}" if !@name
        IL.BindImage(@name)
    end

    def error_check
        if (error_code = IL.GetError) != IL::NO_ERROR
            raise RuntimeError, "An error occured. #{ILU.ErrorString(error_code)}"
        end
    end

    def action
        set_binding
        result = yield
        error_check
        
        result
    end
end
## end of Devil::Image

# initialize Devil and set default config
Devil.init
