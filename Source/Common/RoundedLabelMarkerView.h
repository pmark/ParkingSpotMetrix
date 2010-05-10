//
//  RoundedLabelMarkerView.h
//  Panoramic
//
//  Created by P. Mark Anderson on 2/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "SM3DAR.h"


@interface RoundedLabelMarkerView : SM3DAR_MarkerView {
	UILabel *label;
}

@property (nonatomic, retain) UILabel *label;

@end
