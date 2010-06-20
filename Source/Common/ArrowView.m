//
//  ArrowView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "ArrowView.h"
#import "ArrowFixture.h"

@implementation ArrowView

- (void) buildView {
    self.color = [UIColor purpleColor];
    self.hidden = NO;
    self.zrot = 0.0;
	self.frame = CGRectZero;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"arrow" ofType:@"obj"];
    self.geometry = [[Geometry newOBJFromResource:path] autorelease];
    self.geometry.cullFace = YES;
    sizeScalar = 1.0;
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
    
    if (sizeScalar != 1.0)
        glScalef(sizeScalar, sizeScalar, sizeScalar);
    
    if ([self.point isKindOfClass:[ArrowFixture class]])
    {
        ArrowFixture *fixture = (ArrowFixture*)self.point;

        if (fixture.rotationDegreesZ != 0.0)
    	    glRotatef(fixture.rotationDegreesZ, 0.0, 0.0, 1.0);
        if (fixture.rotationDegreesX != 0.0)
            glRotatef(fixture.rotationDegreesX, 1.0, 0.0, 0.0);
        if (fixture.rotationDegreesY != 0.0)
	        glRotatef(fixture.rotationDegreesY, 0.0, 1.0, 0.0);
    }
    else
    {
        // point arrow down
        glRotatef(-75, 1.0, 0.0, 0.0);

        // face the camera
        glRotatef(45, 0.0, 1.0, 0.0);        
    }

    if (texture)
        [Geometry displaySphereWithTexture:self.texture];
	else
        [self.geometry displayShaded:self.color];
}

- (void) setDistantStyle
{
    self.sizeScalar = 1.0;
    self.color = [UIColor redColor];
}

- (void) setMidrangeStyle
{
    self.sizeScalar = 0.4;
    self.color = [UIColor purpleColor];
}

- (void) setNearbyStyle
{
    self.sizeScalar = 0.06;
    self.color = [UIColor purpleColor];
}

@end
