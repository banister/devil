
#!/usr/bin/env ruby

require 'rubygems'
require 'glut'
require 'opengl'
require 'devil'
require 'thread'

$tex_id = 0

$idle = proc {
    GLUT.PostRedisplay
}

$display = proc {
    GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
    GL.LoadIdentity
    GLU.LookAt(0,0,-5,0,0,0,0,1,0)

    GL.Begin GL::QUADS


    GL.TexCoord(1,0)
    GL.Vertex(1, 1,0)
    GL.TexCoord(1,1)
    GL.Vertex(1, -1,0)
    GL.TexCoord(0,1)
    GL.Vertex(-1, -1,0)
    GL.TexCoord(0,0)
    GL.Vertex(-1, 1,0)

    GL.End

    GLUT.SwapBuffers
}

$reshape = proc { |w,h|
    GL.Viewport(0,0,w,h)
    GL.MatrixMode(GL::PROJECTION)
    GL.LoadIdentity
    GLU.Perspective(45.0, Float(w)/h, 0.01, 100)
    GL.MatrixMode(GL::MODELVIEW)
    GL.LoadIdentity
}

def setup_gl
    GL.ClearColor( 0,0,0,1)
    IL.Init
    ILUT.Renderer(ILUT::OPENGL)
    GL.Enable(GL::DEPTH_TEST)
    GL.DrawBuffer(GL::BACK)
    GL.Disable(GL::CULL_FACE)
    GL.ShadeModel(GL::FLAT)
    GL.Enable(GL::TEXTURE_2D)

    name = IL.GenImages(1)[0]
    IL.BindImage(name)

    if File.directory?("test") then
    	if !File.exist?("test/texture.png") then
    	    raise RuntimeError, "File test/texture.png doesn't exist"
    	end
	IL.LoadImage("test/texture.png")
    else
    	if !File.exist?("texture.png") then
    	    raise RuntimeError, "File texture.png doesn't exist"
    	end
	IL.LoadImage("texture.png")
    end

    $tex_id = ILUT.GLBindMipmaps()
    IL.DeleteImages([name])
    

end

def main
    GLUT.Init
    GLUT.InitDisplayMode(GLUT::DOUBLE | GLUT::RGB | GLUT::DEPTH)
    GLUT.InitWindowSize(800,600)
    GLUT.CreateWindow("Ruby-DevIL test")
    setup_gl
    GLUT.DisplayFunc($display)
    GLUT.ReshapeFunc($reshape)
    GLUT.IdleFunc($idle)
    GLUT.MainLoop
    
    
end

main
