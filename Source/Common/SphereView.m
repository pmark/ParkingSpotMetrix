//
//  SphereView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "SphereView.h"

@implementation SphereView

- (void) buildView 
{
    self.color = [UIColor whiteColor];
    self.hidden = NO;    
    self.zrot = 0.0;    
    self.sizeScalar = 100.0;
	self.frame = CGRectZero;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"sphere" ofType:@"obj"];
    self.geometry = [[Geometry newOBJFromResource:path] autorelease];
    self.geometry.cullFace = YES;
}

- (void) displayGeometry 
{
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
        [Geometry displaySphereWithTexture:self.texture];
    }
	else
    {
        //[self.geometry displayShaded:self.color];
        [self.geometry displayWireframe];
    }
}


@end
