/*
 *  Protocols.h
 *  PubReader2
 *
 *  Created by P. Mark Anderson on 4/22/10.
 *  © Copyright, Digimarc Corporation, USA. All rights reserved.
 *
 */

@protocol TutorialDelegate
- (void) endTutorial;
@end

@protocol DiscoverDelegate
- (void) endDiscoverMode:(NSString*)urlToLoad;
- (void) endDiscoverModeAndShowInfoScreen;
- (void) loadDiscoveredItem:(NSString*)urlToLoad;
- (void) loadTutorial:(UIViewController<TutorialDelegate>*)parent;
@end

@protocol NewsReaderDelegate
- (void) loadURL:(NSURL*)URL;
@end


