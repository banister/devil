#include "ruby_devil_ext.h"
#include <IL/il.h>

struct ImageData {
    ILubyte* data;
};

static VALUE mIL;
static VALUE cImageData;
static VALUE cNullImageData;


inline ILubyte* ImageData2Arr(VALUE obj) {
    struct ImageData* arr;
    Data_Get_Struct(obj, struct ImageData, arr);
    return arr->data;
}

inline VALUE MakeImageData(ILubyte* image_data) {
    struct ImageData* c_data;
    VALUE ret = Data_Make_Struct(cImageData, struct ImageData, 0, NULL, c_data);
    c_data->data = image_data;
    return ret;    
}


static VALUE il_Init(VALUE obj) {
    ilInit();
    return Qnil;
}

static VALUE il_GenImages(VALUE obj, VALUE num_names) {
    ILsizei num = NUM2INT(num_names);
    ILuint* names = ALLOC_N(ILuint, num);
    RArray* ret;
    int i;

    if (!names)
	rb_raise(rb_eRuntimeError, "IL.GenImages memory allocation");

    ilGenImages(num, names);

    ret = RARRAY( rb_ary_new2(num));
    for(i = 0; i < num; ++i)
	rb_ary_push( (VALUE)ret, INT2NUM(names[i]));
    free(names);

    return (VALUE)ret;
}

static VALUE il_BindImage(VALUE obj, VALUE image) {
    ILuint u_image = NUM2INT(image);
    ilBindImage(u_image);
    return Qnil;
}

static VALUE il_DeleteImages(VALUE obj, VALUE images) {
    ILsizei num;
    ILuint* u_images;
    RArray* ary;
    VALUE entry;
    int i = 0;

    if(TYPE(images) != T_ARRAY)
	rb_raise(rb_eTypeError, "type mismatch:%s", rb_class2name(images));

    ary = RARRAY(images);
    num = ary->len;
    u_images = ALLOC_N(ILuint, num);

    for(i = 0; i < num; ++i) {
	entry = rb_ary_entry((VALUE)ary, i);
	u_images[i] = NUM2INT(entry);
    }

    ilDeleteImages(num, u_images);

    free(u_images);
    return Qnil;
}

static VALUE il_LoadImage(VALUE obj, VALUE rb_filename) {
    char* filename = STR2CSTR(rb_filename);
    ILboolean load = ilLoadImage(filename);
    return load ? Qtrue : Qfalse;
}

static VALUE il_Load(VALUE obj, VALUE rb_type, VALUE rb_filename) {
    ILenum type = NUM2INT(rb_type);
    char* filename = STR2CSTR(rb_filename);

    ILboolean load = ilLoad(type, filename);
    return load ? Qtrue : Qfalse;
}

static VALUE il_SaveImage(VALUE obj, VALUE rb_filename) {
    char* filename = STR2CSTR(rb_filename);
    ILboolean load = ilSaveImage(filename);

    return load ? Qtrue : Qfalse;
}

static VALUE il_Save(VALUE obj, VALUE rb_type, VALUE rb_filename) {
    ILenum type = NUM2INT(rb_type);
    char* filename = STR2CSTR(rb_filename);
    ILboolean load = ilSave(type, filename);

    return load ? Qtrue : Qfalse;
}

static VALUE il_TexImage(VALUE obj, VALUE rb_width, VALUE rb_height,
                         VALUE rb_depth, VALUE rb_bpp, VALUE rb_format, VALUE rb_type,
                         VALUE rb_data) {
    ILuint width = NUM2INT(rb_width);
    ILuint height = NUM2INT(rb_height);
    ILuint depth = NUM2INT(rb_depth);
    ILubyte bpp = NUM2INT(rb_bpp);
    ILenum format = NUM2INT(rb_format);
    ILenum type = NUM2INT(rb_type);
    ILvoid* data = ImageData2Arr(rb_data);

    ILboolean flag = ilTexImage(width, height, depth,
                                bpp, format, type, data);
    return flag ? Qtrue : Qfalse;
}

static VALUE il_GetData(VALUE obj) {
    ILubyte* data = ilGetData();
    return MakeImageData(data);
}

ILuint ilCopyPixels(ILuint XOff, ILuint YOff, ILuint ZOff, ILuint Width,
                    ILuint Height, ILuint Depth, ILenum Format, ILenum Type, ILvoid
                    *Data);

static VALUE il_CopyPixels(VALUE obj, VALUE rb_XOff, VALUE rb_YOff, VALUE rb_ZOff,
                           VALUE rb_Width, VALUE rb_Height, VALUE rb_Depth, VALUE rb_Format,
                           VALUE rb_Type, VALUE rb_data) {
    ILuint XOff = NUM2INT(rb_XOff);
    ILuint YOff = NUM2INT(rb_YOff);
    ILuint ZOff = NUM2INT(rb_ZOff);
    ILuint Width = NUM2INT(rb_Width);
    ILuint Height = NUM2INT(rb_Height);
    ILuint Depth = NUM2INT(rb_Depth);
    ILenum Format = NUM2INT(rb_Format);
    ILenum Type = NUM2INT(rb_Type);
    ILvoid* data = ImageData2Arr(rb_data);

    ILuint uint = ilCopyPixels(XOff, YOff, ZOff, Width, Height, Depth, Format, Type, data);
    return INT2FIX(uint);    
}

static VALUE il_SetData(VALUE obj, VALUE rb_Data) {
    ILvoid* data = ImageData2Arr(rb_Data);
    ILboolean flag = ilSetData(data);
    return flag ? Qtrue : Qfalse;
}

static VALUE il_SetPixels(VALUE obj, VALUE rb_XOff, VALUE rb_YOff, VALUE rb_ZOff,
                          VALUE rb_Width, VALUE rb_Height, VALUE rb_Depth, VALUE rb_Format,
                          VALUE rb_Type, VALUE rb_data) {
    ILuint XOff = NUM2INT(rb_XOff);
    ILuint YOff = NUM2INT(rb_YOff);
    ILuint ZOff = NUM2INT(rb_ZOff);
    ILuint Width = NUM2INT(rb_Width);
    ILuint Height = NUM2INT(rb_Height);
    ILuint Depth = NUM2INT(rb_Depth);
    ILenum Format = NUM2INT(rb_Format);
    ILenum Type = NUM2INT(rb_Type);
    ILvoid* data = ImageData2Arr(rb_data);

    ilSetPixels(XOff, YOff, ZOff, Width, Height, Depth, Format, Type, data);
    return Qnil;
}


static VALUE il_CopyImage(VALUE obj, VALUE rb_Src){
    ILuint Src = NUM2INT(rb_Src);
    ILboolean flag = ilCopyImage(Src);
    return flag ? Qtrue : Qfalse;
}

static VALUE il_OverlayImage(VALUE obj, VALUE rb_Source, VALUE rb_XCoord,
                             VALUE rb_YCoord, VALUE rb_ZCoord) {
    ILuint Source = NUM2INT(rb_Source);
    ILint XCoord = NUM2INT(rb_XCoord);
    ILint YCoord = NUM2INT(rb_YCoord);
    ILint ZCoord = NUM2INT(rb_ZCoord);
    ILboolean flag = ilOverlayImage(Source, XCoord, YCoord,ZCoord);
    
    return flag ? Qtrue : Qfalse;
}


static VALUE il_Blit(VALUE obj, VALUE rb_Source, VALUE rb_DestX, VALUE
                     rb_DestY, VALUE rb_DestZ, VALUE rb_SrcX, VALUE rb_SrcY, VALUE
                     rb_SrcZ, VALUE rb_Width, VALUE rb_Height, VALUE rb_Depth) {
    ILuint Source = NUM2INT(rb_Source);
    ILint DestX = NUM2INT(rb_DestX);
    ILint DestY = NUM2INT(rb_DestY);
    ILint DestZ = NUM2INT(rb_DestZ);
    ILint SrcX = NUM2INT(rb_SrcX);
    ILint SrcY = NUM2INT(rb_SrcY);
    ILint SrcZ = NUM2INT(rb_SrcZ);
    ILuint Width = NUM2INT(rb_Width);
    ILuint Height = NUM2INT(rb_Height);
    ILuint Depth = NUM2INT(rb_Depth);

    ILboolean flag = ilBlit(Source, DestX,DestY, DestZ,SrcX, SrcY, SrcZ,
                            Width,Height,Depth);
    return flag ? Qtrue : Qfalse;
}

static VALUE il_GetError(VALUE obj) {
    ILenum num = ilGetError();
    return INT2FIX(num);
}

static VALUE il_ActiveMipmap(VALUE obj, VALUE rb_Number) {
    ILuint Number = NUM2INT(rb_Number);
    ILboolean flag = ilActiveMipmap(Number);
    return flag ? Qtrue : Qfalse;
}

static VALUE il_ActiveImage(VALUE obj, VALUE rb_Number){
    ILuint Number = NUM2INT(rb_Number);
    ILboolean flag = ilActiveImage(Number);
    return flag ? Qtrue : Qfalse;
}

void
InitializeIL() {
    mIL = rb_define_module("IL");
    //////////////////////////////////
    //CLASSES
    //////////////////////////////////
    cImageData = rb_define_class_under(mIL, "ImageData", rb_cObject);
    cNullImageData = MakeImageData(NULL);
    rb_define_const(cImageData, "NullData", cNullImageData);
    //////////////////////////////////
    //METHODS
    //////////////////////////////////
    rb_define_module_function(mIL, "Init", il_Init, 0);
    rb_define_module_function(mIL, "GenImages", il_GenImages, 1);
    rb_define_module_function(mIL, "BindImage", il_BindImage, 1);
    rb_define_module_function(mIL, "DeleteImages", il_DeleteImages, 1);
    rb_define_module_function(mIL, "LoadImage", il_LoadImage, 1);
    rb_define_module_function(mIL, "Load", il_Load, 2);
    rb_define_module_function(mIL, "SaveImage", il_SaveImage, 1);
    rb_define_module_function(mIL, "Save", il_Save, 2);
    rb_define_module_function(mIL, "TexImage", il_TexImage, 7);
    rb_define_module_function(mIL, "GetData", il_GetData, 0);
    rb_define_module_function(mIL, "CopyPixels", il_CopyPixels, 9);
    rb_define_module_function(mIL, "SetData", il_SetData, 1);
    rb_define_module_function(mIL, "SetPixels", il_SetPixels, 9);
    rb_define_module_function(mIL, "CopyImage", il_CopyImage, 1);
    rb_define_module_function(mIL, "OverlayImage", il_OverlayImage, 4);
    rb_define_module_function(mIL, "Blit", il_Blit, 10);
    rb_define_module_function(mIL, "GetError", il_GetError, 0);
    rb_define_module_function(mIL, "ActiveMipmap", il_ActiveMipmap, 1);
    rb_define_module_function(mIL, "ActiveImage", il_ActiveImage, 1);
    
    //////////////////////////////////
    //CONSTANTS
    //////////////////////////////////
    rb_define_const(mIL, "TYPE_UNKNOWN", INT2NUM(IL_TYPE_UNKNOWN));
    rb_define_const(mIL, "BMP", INT2NUM(IL_BMP));
    rb_define_const(mIL, "CUT", INT2NUM(IL_CUT));
    rb_define_const(mIL, "DOOM", INT2NUM(IL_DOOM));
    rb_define_const(mIL, "DOOM_FLAT", INT2NUM(IL_DOOM_FLAT));
    rb_define_const(mIL, "ICO", INT2NUM(IL_ICO));
    rb_define_const(mIL, "JPG", INT2NUM(IL_JPG));
    rb_define_const(mIL, "JFIF", INT2NUM(IL_JFIF));
    rb_define_const(mIL, "LBM", INT2NUM(IL_LBM));
    rb_define_const(mIL, "PCD", INT2NUM(IL_PCD));
    rb_define_const(mIL, "PCX", INT2NUM(IL_PCX));
    rb_define_const(mIL, "PIC", INT2NUM(IL_PIC));
    rb_define_const(mIL, "PNG", INT2NUM(IL_PNG));
    rb_define_const(mIL, "PNM", INT2NUM(IL_PNM));
    rb_define_const(mIL, "SGI", INT2NUM(IL_SGI));
    rb_define_const(mIL, "TGA", INT2NUM(IL_TGA));
    rb_define_const(mIL, "TIF", INT2NUM(IL_TIF));
    rb_define_const(mIL, "CHEAD", INT2NUM(IL_CHEAD));
    rb_define_const(mIL, "RAW", INT2NUM(IL_RAW));
    rb_define_const(mIL, "MDL", INT2NUM(IL_MDL));
    rb_define_const(mIL, "WAL", INT2NUM(IL_WAL));
    rb_define_const(mIL, "LIF", INT2NUM(IL_LIF));
    rb_define_const(mIL, "MNG", INT2NUM(IL_MNG));
    rb_define_const(mIL, "JNG", INT2NUM(IL_JNG));
    rb_define_const(mIL, "GIF", INT2NUM(IL_GIF));
    rb_define_const(mIL, "DDS", INT2NUM(IL_DDS));
    rb_define_const(mIL, "DCX", INT2NUM(IL_DCX));
    rb_define_const(mIL, "PSD", INT2NUM(IL_PSD));
    rb_define_const(mIL, "EXIF", INT2NUM(IL_EXIF));
    rb_define_const(mIL, "PSP", INT2NUM(IL_PSP));
    rb_define_const(mIL, "PIX", INT2NUM(IL_PIX));
    rb_define_const(mIL, "PXR", INT2NUM(IL_PXR));
    rb_define_const(mIL, "XPM", INT2NUM(IL_XPM));
    rb_define_const(mIL, "HDR", INT2NUM(IL_HDR));
    rb_define_const(mIL, "JASC_PAL", INT2NUM(IL_JASC_PAL));

    rb_define_const(mIL, "COLOUR_INDEX", INT2NUM(IL_COLOUR_INDEX));
    rb_define_const(mIL, "COLOR_INDEX", INT2NUM(IL_COLOR_INDEX));
    rb_define_const(mIL, "RGB", INT2NUM(IL_RGB));
    rb_define_const(mIL, "RGBA", INT2NUM(IL_RGBA));
    rb_define_const(mIL, "BGR", INT2NUM(IL_BGR));
    rb_define_const(mIL, "BGRA", INT2NUM(IL_BGRA));
    rb_define_const(mIL, "LUMINANCE", INT2NUM(IL_LUMINANCE));
    rb_define_const(mIL, "LUMINANCE_ALPHA", INT2NUM(IL_LUMINANCE_ALPHA));

    rb_define_const(mIL, "UNSIGNED_BYTE", INT2NUM(IL_UNSIGNED_BYTE));
    rb_define_const(mIL, "SHORT", INT2NUM(IL_SHORT));
    rb_define_const(mIL, "UNSIGNED_SHORT", INT2NUM(IL_UNSIGNED_SHORT));
    rb_define_const(mIL, "INT", INT2NUM(IL_INT));
    rb_define_const(mIL, "UNSIGNED_INT", INT2NUM(IL_UNSIGNED_INT));
    rb_define_const(mIL, "FLOAT", INT2NUM(IL_FLOAT));
    rb_define_const(mIL, "DOUBLE", INT2NUM(IL_DOUBLE));

    rb_define_const(mIL, "NO_ERROR", INT2NUM(IL_NO_ERROR));
    rb_define_const(mIL, "INVALID_ENUM", INT2NUM(IL_INVALID_ENUM));
    rb_define_const(mIL, "OUT_OF_MEMORY", INT2NUM(IL_OUT_OF_MEMORY));
    rb_define_const(mIL, "FORMAT_NOT_SUPPORTED", INT2NUM(IL_FORMAT_NOT_SUPPORTED));
    rb_define_const(mIL, "INTERNAL_ERROR", INT2NUM(IL_INTERNAL_ERROR));
    rb_define_const(mIL, "INVALID_VALUE", INT2NUM(IL_INVALID_VALUE));
    rb_define_const(mIL, "ILLEGAL_OPERATION", INT2NUM(IL_ILLEGAL_OPERATION));
    rb_define_const(mIL, "ILLEGAL_FILE_VALUE", INT2NUM(IL_ILLEGAL_FILE_VALUE));
    rb_define_const(mIL, "INVALID_FILE_HEADER", INT2NUM(IL_INVALID_FILE_HEADER));
    rb_define_const(mIL, "INVALID_PARAM", INT2NUM(IL_INVALID_PARAM));
    rb_define_const(mIL, "COULD_NOT_OPEN_FILE", INT2NUM(IL_COULD_NOT_OPEN_FILE));
    rb_define_const(mIL, "INVALID_EXTENSION", INT2NUM(IL_INVALID_EXTENSION));
    rb_define_const(mIL, "FILE_ALREADY_EXISTS", INT2NUM(IL_FILE_ALREADY_EXISTS));
    rb_define_const(mIL, "OUT_FORMAT_SAME", INT2NUM(IL_OUT_FORMAT_SAME));
    rb_define_const(mIL, "STACK_OVERFLOW", INT2NUM(IL_STACK_OVERFLOW));
    rb_define_const(mIL, "STACK_UNDERFLOW", INT2NUM(IL_STACK_UNDERFLOW));
    rb_define_const(mIL, "INVALID_CONVERSION", INT2NUM(IL_INVALID_CONVERSION));
    rb_define_const(mIL, "BAD_DIMENSIONS", INT2NUM(IL_BAD_DIMENSIONS));
    rb_define_const(mIL, "FILE_READ_ERROR", INT2NUM(IL_FILE_READ_ERROR)); 
    rb_define_const(mIL, "FILE_WRITE_ERROR", INT2NUM(IL_FILE_WRITE_ERROR));
    rb_define_const(mIL, "LIB_GIF_ERROR", INT2NUM(IL_LIB_GIF_ERROR));
    rb_define_const(mIL, "LIB_JPEG_ERROR", INT2NUM(IL_LIB_JPEG_ERROR));
    rb_define_const(mIL, "LIB_PNG_ERROR", INT2NUM(IL_LIB_PNG_ERROR));
    rb_define_const(mIL, "LIB_TIFF_ERROR", INT2NUM(IL_LIB_TIFF_ERROR));
    rb_define_const(mIL, "LIB_MNG_ERROR", INT2NUM(IL_LIB_MNG_ERROR));
    rb_define_const(mIL, "UNKNOWN_ERROR", INT2NUM(IL_UNKNOWN_ERROR));

}
//////////////////////////////////////////

//////////////////////////////////////////

