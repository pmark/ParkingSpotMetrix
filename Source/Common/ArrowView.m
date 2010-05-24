//
//  ArrowView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "ArrowView.h"
#import "ArrowFixture.h"

@implementation ArrowView

@synthesize scalar;


- (void) buildView {
    self.hidden = NO;
    
    self.zrot = 0.0;
	self.frame = CGRectZero;

    NSString* path = [[NSBundle mainBundle] pathForResource:@"arrow" ofType:@"obj"];
    self.geometry = [[Geometry newOBJFromResource:path] autorelease];
    self.geometry.cullFace = YES;
    scalar = 0;
}

- (void) displayGeometry 
{
    if (texture == nil && [textureName length] > 0) 
    {
        NSLog(@"Loading texture named %@", textureName);
        NSString *textureExtension = [[textureName componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *textureBaseName = [textureName stringByDeletingPathExtension];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:textureBaseName ofType:textureExtension];
        NSLog(@"loading image at path: %@", imagePath);
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath];         
        UIImage * textureImage =  [[UIImage alloc] initWithData:imageData];        
        CGImageRef cgi = textureImage.CGImage;
        self.texture = [[Texture newTextureFromImage:cgi] autorelease];        
        [imageData release];
        [textureImage release];
    }
    
    ArrowFixture *fixture = (ArrowFixture*)self.point;
    glRotatef(fixture.rotationDegrees, 0.0, 1.0, 0.0);
    glRotatef(fixture.heading, 1.0, 0.0, 0.0);
    
    if (texture)
        [Geometry displaySphereWithTexture:self.texture];
	else
        [self.geometry displayShaded:self.color];
}

@end
