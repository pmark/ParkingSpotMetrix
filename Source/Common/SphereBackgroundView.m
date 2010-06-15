//
//  SphereBackgroundView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "SphereBackgroundView.h"

@implementation SphereBackgroundView

- (void) buildView {
    self.color = [UIColor whiteColor];
    self.hidden = NO;
    self.sizeScalar = 10000.0f;
    self.zrot = 0.0;
	self.frame = CGRectZero;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"sphere" ofType:@"obj"];
    self.geometry = [[Geometry newOBJFromResource:path] autorelease];
    self.geometry.cullFace = YES;
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
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath]; 
        UIImage *textureImage =  [[UIImage alloc] initWithData:imageData];
        CGImageRef cgi = textureImage.CGImage;
        self.texture = [[Texture newTextureFromImage:cgi] autorelease];        
        [imageData release];
        [textureImage release];
    }

    glScalef(-sizeScalar, sizeScalar, sizeScalar);
    glRotatef(180, 1, 0, 0);
    
    //[self updateTexture];
    
    if (texture)
    {
        //    glDepthMask(0);
        
        [Geometry displaySphereWithTexture:self.texture];
        //    glDepthMask(1);
    }
	else
    {
        [self.geometry displayShaded:self.color];
        //[self.geometry displayWireframe];
    }
    
    
//    glPopMatrix();
}


@end
