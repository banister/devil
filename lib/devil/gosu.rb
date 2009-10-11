require 'texplay'
require 'devil'

module TexPlay

    # save a Gosu::Image to +file+
    def save(file)
        capture { 
            save_image = Devil.from_blob(self.to_blob, self.width, self.height)
            save_image.flip
            save_image.save(file)
        }
    end

    # convert a Gosu::Image to a Devil::Image
    def devil_image
        devil_img = nil
        capture {
            devil_img = Devil.from_blob(self.to_blob, self.width, self.height)
            devil_img.flip
        }
        devil_img
    end
end

class Gosu::Window

    # this function does not yet work :/
    def save_screenshot(file)
        canvas_texture_id = glGenTextures(1).first

        glEnable(GL_TEXTURE_2D)
        glBindTexture(GL_TEXTURE_2D, canvas_texture_id)
        
        glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, 1)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, self.width, self.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, "\0" * self.width * self.height * 4)
        
        glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 0, 0, self.width, self.height, 0)

        data = glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE)

        img = Devil.from_blob(data, self.width, self.height)
        
        img.save(file)
    end

end
