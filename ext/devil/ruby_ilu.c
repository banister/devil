#include <ruby.h>
#include <IL/ilu.h>
#include "ruby_devil_ext.h"

static VALUE mILU;

static VALUE ilu_Init(VALUE obj) {
    iluInit();
    return Qnil;
}

static VALUE ilu_ErrorString(VALUE obj, VALUE rb_error) {
    ILenum num = NUM2INT(rb_error);
    const char* error = iluErrorString(num);
    return rb_str_new2(error);
}

static VALUE ilu_Alienify(VALUE obj) {
    ILboolean flag = iluAlienify();
    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_BlurAvg(VALUE obj, VALUE rb_iter) {
    ILuint iter = NUM2INT(rb_iter);
    ILboolean flag = iluBlurAvg(iter);
    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_BlurGaussian(VALUE obj, VALUE rb_iter) {
    ILuint iter = NUM2INT(rb_iter);
    ILboolean flag = iluBlurGaussian(iter);
    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_Contrast(VALUE obj, VALUE rb_cont) {
    ILfloat cont = NUM2DBL(rb_cont);
    ILboolean flag = iluContrast(cont);
    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_Equalize(VALUE obj) {
    ILboolean flag = iluEqualize();
    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_GammaCorrect (VALUE obj, VALUE rb_gamma) {
    ILfloat gamma = NUM2DBL(rb_gamma);
    ILboolean flag = iluGammaCorrect(gamma);
    return flag ? Qtrue : Qfalse;
}
static VALUE ilu_Negative (VALUE obj) {
    ILboolean flag = iluNegative();
    return flag ? Qtrue : Qfalse;
}
static VALUE ilu_Noisify (VALUE obj, VALUE rb_tolerance) {
    ILclampf tolerance = NUM2DBL(rb_tolerance);
    ILboolean flag = iluNoisify(tolerance);
    return flag ? Qtrue : Qfalse;
}
static VALUE ilu_Pixelize (VALUE obj, VALUE rb_pix_size) {
    ILuint pix = NUM2INT(rb_pix_size);
    ILboolean flag = iluPixelize(pix);
    return flag ? Qtrue : Qfalse;
}
static VALUE ilu_Sharpen (VALUE obj, VALUE rb_factor, VALUE rb_iter) {
    ILfloat factor = NUM2DBL(rb_factor);
    ILuint iter = NUM2INT(rb_iter);
    ILboolean flag = iluSharpen(factor, iter);
    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_Scale(VALUE obj, VALUE rb_Width, VALUE rb_Height, VALUE rb_Depth) {
    ILuint Width = NUM2INT(rb_Width);
    ILuint Height = NUM2INT(rb_Height);
    ILuint Depth = NUM2INT(rb_Depth);
    ILboolean flag = iluScale(Width, Height, Depth);
    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_ImageParameter(VALUE obj, VALUE rb_PName, VALUE rb_Param) {
    ILenum PName = NUM2INT(rb_PName);
    ILenum Param = NUM2INT(rb_Param);
    iluImageParameter(PName, Param);
    return Qnil;
}

static VALUE ilu_BuildMipmaps(VALUE obj) {
    ILboolean flag = iluBuildMipmaps();
    return flag ? Qtrue : Qfalse;
}

/* functions added by banisterfiend */
static VALUE ilu_FlipImage(VALUE obj) {
    ILboolean flag = iluFlipImage();
    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_Rotate(VALUE obj, VALUE rb_angle) {
    ILfloat angle = NUM2DBL(rb_angle);

    ILboolean flag = iluRotate(angle);

    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_Crop(VALUE obj, VALUE rb_XOff, VALUE rb_YOff, VALUE rb_ZOff, VALUE rb_width, VALUE rb_height, VALUE rb_depth)
{
    ILuint XOff = NUM2INT(rb_XOff);
    ILuint YOff = NUM2INT(rb_YOff);
    ILuint ZOff = NUM2INT(rb_ZOff);
    ILuint width = NUM2INT(rb_width);
    ILuint height = NUM2INT(rb_height);
    ILuint depth = NUM2INT(rb_depth);
                       	
    ILboolean flag = iluCrop(XOff, YOff, ZOff, width, height, depth);

    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_EnlargeCanvas(VALUE obj, VALUE rb_width, VALUE rb_height, VALUE rb_depth)
{
    ILuint width = NUM2INT(rb_width);
    ILuint height = NUM2INT(rb_height);
    ILuint depth = NUM2INT(rb_depth);

    ILboolean flag = iluEnlargeCanvas(width, height, depth);

    return flag ? Qtrue : Qfalse;
}

static VALUE ilu_EdgeDetectP(VALUE obj)
{
    ILboolean flag = iluEdgeDetectP();

    return flag ? Qtrue : Qfalse;    
}

static VALUE ilu_EdgeDetectS(VALUE obj)
{
    ILboolean flag = iluEdgeDetectS();

    return flag ? Qtrue : Qfalse;    
}

static VALUE ilu_Emboss(VALUE obj)
{
    ILboolean flag = iluEmboss();

    return flag ? Qtrue : Qfalse;    
}

static VALUE ilu_Mirror(VALUE obj)
{
    ILboolean flag = iluMirror();

    return flag ? Qtrue : Qfalse;    
}

static VALUE ilu_SwapColours(VALUE obj)
{
    ILboolean flag = iluSwapColours();

    return flag ? Qtrue : Qfalse;    
}

/* end of functions added by banisterfiend */

void
InitializeILU() {
    mILU = rb_define_module("ILU");
    rb_define_module_function(mILU, "Init", ilu_Init, 0);
    rb_define_module_function(mILU, "ErrorString", ilu_ErrorString, 1);
    rb_define_module_function(mILU, "Alienify", ilu_Alienify, 0);
    rb_define_module_function(mILU, "BlurAvg", ilu_BlurAvg, 1);
    rb_define_module_function(mILU, "BlurGaussian", ilu_BlurGaussian, 1);
    rb_define_module_function(mILU, "Contrast",ilu_Contrast , 1);
    rb_define_module_function(mILU, "Equalize",ilu_Equalize , 0);
    rb_define_module_function(mILU, "GammaCorrect",ilu_GammaCorrect , 1);
    rb_define_module_function(mILU, "Negative", ilu_Negative , 0);
    rb_define_module_function(mILU, "Noisify", ilu_Noisify , 1);
    rb_define_module_function(mILU, "Pixelize", ilu_Pixelize , 1);
    rb_define_module_function(mILU, "Sharpen", ilu_Sharpen, 2);
    rb_define_module_function(mILU, "Scale", ilu_Scale , 3);
    rb_define_module_function(mILU, "ImageParameter", ilu_ImageParameter , 2);
    rb_define_module_function(mILU, "BuildMipmaps",  ilu_BuildMipmaps, 0);

    /* methods added by banisterfiend */
    rb_define_module_function(mILU, "FlipImage",  ilu_FlipImage, 0);
    rb_define_module_function(mILU, "Rotate",  ilu_Rotate, 1);
    rb_define_module_function(mILU, "Crop",  ilu_Crop, 6);
    rb_define_module_function(mILU, "EnlargeCanvas",  ilu_EnlargeCanvas, 3);
    rb_define_module_function(mILU, "EdgeDetectP", ilu_EdgeDetectP, 0);
    rb_define_module_function(mILU, "EdgeDetectS", ilu_EdgeDetectS, 0);
    rb_define_module_function(mILU, "Emboss", ilu_Emboss, 0);
    rb_define_module_function(mILU, "Mirror", ilu_Mirror, 0);
    rb_define_module_function(mILU, "SwapColours", ilu_SwapColours, 0);
    /* end of functions added by banisterfiend */

    /* constants added by banisterfiend */
    rb_define_const(mILU, "FILTER", INT2NUM(ILU_FILTER));
    rb_define_const(mILU, "NEAREST", INT2NUM(ILU_NEAREST));
    rb_define_const(mILU, "LINEAR", INT2NUM(ILU_LINEAR));
    rb_define_const(mILU, "BILINEAR", INT2NUM(ILU_BILINEAR));
    rb_define_const(mILU, "SCALE_BOX", INT2NUM(ILU_SCALE_BOX));
    rb_define_const(mILU, "SCALE_TRIANGLE", INT2NUM(ILU_SCALE_TRIANGLE));
    rb_define_const(mILU, "SCALE_BELL", INT2NUM(ILU_SCALE_BELL));
    rb_define_const(mILU, "SCALE_BSPLINE", INT2NUM(ILU_SCALE_BSPLINE));
    rb_define_const(mILU, "SCALE_LANCZOS3", INT2NUM(ILU_SCALE_LANCZOS3));
    rb_define_const(mILU, "SCALE_MITCHELL", INT2NUM(ILU_SCALE_MITCHELL));

    rb_define_const(mILU, "PLACEMENT", INT2NUM(ILU_PLACEMENT));
    rb_define_const(mILU, "UPPER_LEFT", INT2NUM(ILU_UPPER_LEFT));
    rb_define_const(mILU, "LOWER_LEFT", INT2NUM(ILU_LOWER_LEFT));
    rb_define_const(mILU, "LOWER_RIGHT", INT2NUM(ILU_LOWER_RIGHT));
    rb_define_const(mILU, "UPPER_RIGHT", INT2NUM(ILU_UPPER_RIGHT));
    rb_define_const(mILU, "CENTER", INT2NUM(ILU_CENTER));
    /* end of constants added by banisterfiend */

}
