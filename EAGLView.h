#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


@interface EAGLView : UIView {
    
@private
    // The pixel dimensions of the backbuffer
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    // OpenGL names for the renderbuffer and framebuffer used to render to this view
    GLuint viewRenderbuffer, viewFramebuffer;	
}

- (void)drawView;
- (void)setImageForBlur:(UIImage *)img;

@end
