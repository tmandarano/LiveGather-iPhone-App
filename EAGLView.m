#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "EAGLView.h"
#import "Imaging.h"


// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

@end


@implementation EAGLView

@synthesize context;


// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
			kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
			nil];
			        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            [self release];
            return nil;
        }
        
		// Create system framebuffer object. The backing will be allocated in -reshapeFramebuffer
		glGenFramebuffersOES(1, &viewFramebuffer);
		glGenRenderbuffersOES(1, &viewRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
		
		// Perform additional one-time GL initialization
		initGL();
    }
    return self;
}

- (void)setImageForBlur:(UIImage *)img {
	
}

- (void)drawView
{
 	int mode = 2;
	float value = 0.5;
	NSLog(@"Redrawing the view");
	// This application only creates a single GL context, so it is already current here.
	// If there are multiple contexts, ensure the correct one is current before drawing.
	drawGL(backingWidth, backingHeight, value, mode);

	// This application only creates a single (color) renderbuffer, so it is already bound here.
	// If there are multiple renderbuffers (for example color and depth), ensure the correct one is bound here.
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)reshapeFramebuffer
{
	// Allocate GL color buffer backing, matching the current layer size
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// This application only needs color. If depth and/or stencil are needed, ensure they are also resized here.
	rt_assert(GL_FRAMEBUFFER_COMPLETE_OES == glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
	glCheckError();
}


- (void)layoutSubviews
{
    [self reshapeFramebuffer];
    [self drawView];
}


- (void)dealloc
{        
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
	self.context = nil;
    [super dealloc];
}

@end
