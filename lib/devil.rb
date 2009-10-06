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

# initialize DevIL
IL.Init

# default options
IL.Enable(IL::FILE_OVERWRITE)
ILU.ImageParameter(ILU::FILTER, ILU::BILINEAR)

module Devil
    def self.load_image(file)
        name = IL.GenImages(1).first
        IL.BindImage(name)
        IL.LoadImage(file)

        Image.new(name, file)
    end

    class Image
        def initialize(name, file)
            @name = name
            @file = file

            ObjectSpace.define_finalizer( self, proc { IL.DeleteImages(1, [name]) } )
        end

        def save(file = @file)
            set_binding
            IL.SaveImage(file)
        end

        def resize(width, height)
            set_binding
            ILU.Scale(width, height, 1)
        end

        private
        
        def set_binding
            IL.BindImage(@name)
        end
    end
end
