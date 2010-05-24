//
//  SphereView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "SphereView.h"

@implementation SphereView

- (void) buildView {
    self.hidden = NO;
    
    self.zrot = 0.0;
    
	self.frame = CGRectZero;
}

- (void) displayGeometry 
{
    // If the texture has not been loaded, load it.
    
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

    // Temporary fix - we are getting a translation in the modelview
    // matrix when we should not.  build our own.
    
//    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];    
//    CATransform3D xfm = [sm3dar cameraTransform];
//    xfm.m41 = xfm.m42 = xfm.m43 = 0.0f;
    
//    glMatrixMode(GL_MODELVIEW);
//    glPushMatrix();
//    glLoadMatrixf((const GLfloat *)&xfm);

    // draw sphere

    CGFloat scalar = 3000.0f;
    glScalef (-scalar, scalar, scalar);
    glRotatef (180, 1, 0, 0);
    
    //[self updateTexture];
    
    glDepthMask(0);
    if (self.texture) {
        [Geometry displaySphereWithTexture:self.texture];
    }  
    glDepthMask(1);
    
//    glPopMatrix();
}


@end
