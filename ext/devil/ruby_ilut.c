#include <ruby.h>
#include <IL/ilut.h>
#include "ruby_devil_ext.h"

static VALUE mILUT;

static VALUE ilut_Renderer(VALUE obj, VALUE ilut_enum) {
    ILenum renderer = NUM2INT(ilut_enum);
    ilutRenderer(renderer);
    return Qnil;
}

static VALUE ilut_Enable(VALUE obj, VALUE rb_Mode) {
    ILenum Mode = NUM2INT(rb_Mode);
    ILboolean flag = ilutEnable(Mode);
    return flag ? Qtrue : Qfalse;
}

static VALUE ilut_GLTexImage(VALUE obj, VALUE rb_Level) {
    GLuint Level = NUM2INT(rb_Level);
    ILboolean flag = ilutGLTexImage(Level);
    return flag ? Qtrue : Qfalse;
}

static VALUE ilut_GLBindTexImage(VALUE obj) {
    GLuint ret = ilutGLBindTexImage();
    return INT2FIX(ret);
}

static VALUE ilut_GLBuildMipmaps(VALUE obj) {
    ILboolean flag = ilutGLBuildMipmaps();
    return flag ? Qtrue : Qfalse;
}

static VALUE ilut_GLBindMipmaps(VALUE obj) {
    ILuint ret = ilutGLBindMipmaps();
    return INT2FIX(ret);
}

static VALUE ilut_GLLoadImage(VALUE obj, VALUE rb_FileName) {
    const ILstring FileName = StringValuePtr(rb_FileName);
    ILuint ret = ilutGLLoadImage(FileName);
    return INT2FIX(ret);
}

static VALUE ilut_GLScreen(VALUE obj) {
    ILboolean flag = ilutGLScreen();
    return flag ? Qtrue : Qfalse;
}

static VALUE ilut_GLScreenie(VALUE obj) {
    ILboolean flag = ilutGLScreenie();
    return flag ? Qtrue : Qfalse;
}



void 
InitializeILUT() {
    mILUT = rb_define_module("ILUT");
    //////////////////////////////////
    //METHODS
    //////////////////////////////////
    rb_define_module_function(mILUT, "Renderer", ilut_Renderer, 1);
    rb_define_module_function(mILUT, "Enable", ilut_Enable , 1);
    rb_define_module_function(mILUT, "GLTexImage", ilut_GLTexImage, 1);
    rb_define_module_function(mILUT, "GLBindTexImage", ilut_GLBindTexImage, 0);
    rb_define_module_function(mILUT, "GLBuildMipmaps", ilut_GLBuildMipmaps , 0);
    rb_define_module_function(mILUT, "GLBindMipmaps", ilut_GLBindMipmaps , 0);
    rb_define_module_function(mILUT, "GLLoadImage", ilut_GLLoadImage, 1);
    rb_define_module_function(mILUT, "GLScreen", ilut_GLScreen , 1);
    rb_define_module_function(mILUT, "GLScreenie", ilut_GLScreenie , 1);

    //////////////////////////////////
    //CONSTANTS
    //////////////////////////////////
    rb_define_const(mILUT, "OPENGL", INT2NUM(ILUT_OPENGL));
    rb_define_const(mILUT, "ALLEGRO", INT2NUM(ILUT_ALLEGRO));
    rb_define_const(mILUT, "WIN32", INT2NUM(ILUT_WIN32));
    rb_define_const(mILUT, "DIRECT3D8", INT2NUM(ILUT_DIRECT3D8));
    rb_define_const(mILUT, "DIRECT3D9", INT2NUM(ILUT_DIRECT3D9));

    rb_define_const(mILUT, "PALETTE_MODE", INT2NUM(ILUT_PALETTE_MODE));
    rb_define_const(mILUT, "OPENGL_CONV", INT2NUM(ILUT_OPENGL_CONV));
    rb_define_const(mILUT, "D3D_MIPLEVELS", INT2NUM(ILUT_D3D_MIPLEVELS));
    rb_define_const(mILUT, "MAXTEX_WIDTH", INT2NUM(ILUT_MAXTEX_WIDTH));
    rb_define_const(mILUT, "MAXTEX_HEIGHT", INT2NUM(ILUT_MAXTEX_HEIGHT));
    rb_define_const(mILUT, "MAXTEX_DEPTH", INT2NUM(ILUT_MAXTEX_DEPTH));
    rb_define_const(mILUT, "GL_USE_S3TC", INT2NUM(ILUT_GL_USE_S3TC));
    rb_define_const(mILUT, "D3D_USE_DXTC", INT2NUM(ILUT_D3D_USE_DXTC));
    rb_define_const(mILUT, "GL_GEN_S3TC", INT2NUM(ILUT_GL_GEN_S3TC));
    rb_define_const(mILUT, "D3D_GEN_DXTC", INT2NUM(ILUT_D3D_GEN_DXTC));
    rb_define_const(mILUT, "S3TC_FORMAT", INT2NUM(ILUT_S3TC_FORMAT));
    rb_define_const(mILUT, "DXTC_FORMAT", INT2NUM(ILUT_DXTC_FORMAT));
    rb_define_const(mILUT, "D3D_POOL", INT2NUM(ILUT_D3D_POOL));
    rb_define_const(mILUT, "D3D_ALPHA_KEY_COLOR", INT2NUM(ILUT_D3D_ALPHA_KEY_COLOR));
    rb_define_const(mILUT, "D3D_ALPHA_KEY_COLOUR", INT2NUM(ILUT_D3D_ALPHA_KEY_COLOUR));
}
