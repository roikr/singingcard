//
//  MainViewController.h
//  SingingCard
//
//  Created by Roee Kremer on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//@class CustomFontTextField;
//@class CustomImageView;


@interface MainViewController : UIViewController
{
       
    BOOL animating;
    NSInteger animationFrameInterval;
    CADisplayLink *displayLink;
	
	UIView *buttonsView;
	
	BOOL bAnimatingRecord;
	
//	CustomImageView *shareProgressView;

	UIButton *_cameraToggleButton;
	
}




@property (nonatomic, retain) IBOutlet UIView *buttonsView;
//@property (nonatomic,retain ) IBOutlet CustomImageView *shareProgressView;


@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic,retain) IBOutlet UIButton *cameraToggleButton;





- (IBAction) shoot:(id)sender;
- (IBAction) stop:(id)sender;
- (IBAction) preview:(id)sender;
- (IBAction) play:(id)sender;
- (IBAction) stop:(id)sender;
- (IBAction) share:(id)sender;
- (IBAction)cameraToggle:(id)sender;

- (void)updateViews;
- (void) setShareProgress:(float) progress;


@end
