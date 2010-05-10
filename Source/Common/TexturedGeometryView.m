//
//  TexturedGeometryView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "TexturedGeometryView.h"
#import "Constants.h"

@implementation TexturedGeometryView

@synthesize zrot, color, geometry, texture, textureName, textureURL, artworkFetcher;

- (id) initWithTextureNamed:(NSString*)name {
  self.textureName = name;
  if (self = [super initWithFrame:CGRectZero]) {    
  }
  return self;
}

- (id) initWithTextureURL:(NSURL*)url {
  self.textureURL = url;
  if (self = [super initWithFrame:CGRectZero]) {    
  }
  return self;
}

- (void) dealloc {
  NSLog(@"\n\n[TexturedGeometryView] dealloc\n\n");
  RELEASE(color);
  RELEASE(geometry);
  RELEASE(texture);
  RELEASE(textureName);
  RELEASE(textureURL);
  RELEASE(artworkFetcher);
  [super dealloc];
}


#pragma mark -
/*
// Subclasses should implement didReceiveFocus
- (void) didReceiveFocus {
}
*/

#pragma mark -
- (void) updateTexture:(UIImage*)textureImage {
  if (textureImage) {
    NSLog(@"[TexturedGeometryView] updating texture with %@", textureImage);
    [texture replaceTextureWithImage:textureImage.CGImage];
  }
}

- (void)artworkFetcher:(AsyncArtworkFetcher *)fetcher didFinish:(UIImage *)artworkImage {  
  [self updateImage:artworkImage];
}

- (void) updateImage:(UIImage*)img {
  NSLog(@"[TexturedGeometryView] resizing image from original: %f, %f", img.size.width, img.size.height);
  img = [self resizeImage:img];
  //NSLog(@"[TexturedGeometryView] DONE: %f, %f", img.size.width, img.size.height);
  [self updateTexture:img];
}

- (UIImage*) resizeImage:(UIImage*)originalImage {
	//CGPoint topCorner = CGPointMake(0, 0);
	CGSize targetSize = CGSizeMake(512, 256);	
	
	UIGraphicsBeginImageContext(targetSize);	
	[originalImage drawInRect:CGRectMake(0, 0, 512, 256)];	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	
	return result;	
}

- (void) fetchTextureImage:(NSURL*)url {
  if (self.artworkFetcher == nil) {
    self.artworkFetcher = [[[AsyncArtworkFetcher alloc] init] autorelease];
    artworkFetcher.delegate = self;
  }

  artworkFetcher.url = url;
  [artworkFetcher fetch];    
  NSLog(@"[TexturedGeometryView] fetching image at %@", url);
}  

// Subclasses should implement displayGeometry
- (void) displayGeometry {
}

- (void) drawInGLContext {
  [self displayGeometry];
}

@end
