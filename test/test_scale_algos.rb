require 'rubygems'
require 'devil'
 
algorithms = {
    ILU::NEAREST => :nearest,
    ILU::LINEAR => :linear,
    ILU::BILINEAR => :bilinear,
    ILU::SCALE_BOX => :scale_box,
    ILU::SCALE_TRIANGLE => :scale_triangle,
    ILU::SCALE_BELL => :scale_bell,
    ILU::SCALE_BSPLINE => :scale_bspline,
    ILU::SCALE_LANCZOS3 => :scale_lanczos3,
    ILU::SCALE_MITCHELL => :scale_mitchell
}
 
 
algorithms.each do |key, value|
  puts "Generating image using filter: #{value}"
  IL.Init
 
  name = IL.GenImages(1)[0]
  IL.BindImage(name)
  IL.LoadImage("texture.jpg")
  ILU.ImageParameter(ILU::FILTER, key)
 
  ILU.Scale(100, 100, 1)
  IL.Enable(IL::FILE_OVERWRITE)
  IL.SaveImage("scaling_test_#{value}.jpg")
  
end
