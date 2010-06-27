//
//  GroundPlaneView.m
//

#import <OpenGLES/ES1/gl.h>
#import "GroundPlaneView.h"
#import "SM3DAR.h"

@implementation GroundPlaneView

- (void) buildView {
    self.hidden = NO;
    
    self.zrot = 0.0;
    
	self.frame = CGRectZero;
}

#define GROUNDPLANE_SIZE 853

static float triangleVertex[4][5] =
{
    // x y z u v
    { -GROUNDPLANE_SIZE, -GROUNDPLANE_SIZE, GROUNDPLANE_ZPOS, 0.0, 0.0 },
    { +GROUNDPLANE_SIZE, -GROUNDPLANE_SIZE, GROUNDPLANE_ZPOS, 1.0, 0.0 },
    { +GROUNDPLANE_SIZE, +GROUNDPLANE_SIZE, GROUNDPLANE_ZPOS, 1.0, 1.0 },
    { -GROUNDPLANE_SIZE, +GROUNDPLANE_SIZE, GROUNDPLANE_ZPOS, 0.0, 1.0 }
};

static unsigned short triangleIndex[6] = 
{
    0, 1, 2, 0, 2, 3
};

- (void) displayGeometry 
{
    // If texture has not been loaded, load it.

    if (texture == nil && [textureName length] > 0) 
    {
        NSLog(@"Loading texture named %@", textureName);
        NSString *textureExtension = [[textureName componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *textureBaseName = [textureName stringByDeletingPathExtension];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:textureBaseName ofType:textureExtension];
        NSLog(@"loading image at path: %@", imagePath);
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath]; 
        
        UIImage *textureImage =  [[UIImage alloc] initWithData:imageData];

        CGImageRef cgi = textureImage.CGImage;
        self.texture = [[Texture newTextureFromImage:cgi] autorelease];   
        
        [imageData release];
        [textureImage release];
    }

    // Temporary fix - we are getting a translation in the modelview
    // matrix when we should not.  build our own.
    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];    
    CATransform3D xfm = [sm3dar cameraTransform];
    xfm.m41 = xfm.m42 = xfm.m43 = 0.0f;
    
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glLoadMatrixf((const GLfloat *)&xfm);

    // Display the map.

    glScalef (-1, 1, 1);
  	glRotatef(180.0, 0, 0, 1);

    glDepthMask(0);
    
    if (self.texture) 
    {
        // Render to opengl.
        // Setup fog.
        
        // Fog color should match sphere gradient at equator.
        GLfloat fogColor[4] = {0.8f, 0.8f, 0.9f, 1.0f}; 
        glFogfv(GL_FOG_COLOR, fogColor);       

        glFogf(GL_FOG_MODE, GL_LINEAR);
        glFogf(GL_FOG_DENSITY, 1.0); 
        
        glFogf(GL_FOG_START, 0.0);            
        glFogf(GL_FOG_END, GROUNDPLANE_SIZE);                      
        
        glHint(GL_FOG_HINT, GL_NICEST);  
        
        glEnable(GL_FOG);          
        
        // Setup texture mapping.
        
        glBindTexture(GL_TEXTURE_2D, self.texture.handle);

        glColor4f(1,1,1,1);
        glDisable(GL_LIGHTING);

        glDisable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        glDisable(GL_CULL_FACE);
        glEnable(GL_TEXTURE_2D);

        glEnableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);

        glVertexPointer(3, GL_FLOAT, sizeof(float) * 5, &triangleVertex[0][0]);
        glTexCoordPointer(2, GL_FLOAT, sizeof(float) * 5, &triangleVertex[0][3]);

        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, triangleIndex);
        
        glDisable(GL_FOG);
    }  
    
    glDepthMask(1);
    
    glPopMatrix();
}


@end
