//
//  MainViewController.h
//  SingingCard
//
//  Created by Roee Kremer on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

class testApp;
@class EAGLView;
@class CustomFontTextField;
@class CustomImageView;
@class ExportManager;
@class OpenGLTOMovie;

@interface MainViewController : UIViewController
{
    EAGLContext *context;
   
    BOOL animating;
    NSInteger animationFrameInterval;
    CADisplayLink *displayLink;
	
	UIView *renderView;
	UILabel *renderLabel;
	UITextView *renderTextView;
	
	BOOL bAnimatingRecord;
	
	CustomImageView *shareProgressView;
	CustomImageView *renderProgressView;
	
	ExportManager *exportManager;
	OpenGLTOMovie *renderManager;
	
	EAGLView *eaglView;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

@property (nonatomic, retain) IBOutlet UIView *renderView;
@property (nonatomic, retain) IBOutlet UILabel *renderLabel;
@property (nonatomic, retain) IBOutlet UITextView *renderTextView;

@property (nonatomic,retain ) IBOutlet CustomImageView *shareProgressView;
@property (nonatomic,retain ) IBOutlet CustomImageView *renderProgressView;

@property (nonatomic, retain) ExportManager *exportManager;
@property (nonatomic, retain) OpenGLTOMovie *renderManager;

@property (nonatomic, retain) IBOutlet EAGLView *eaglView;
@property (readonly) testApp *OFSAptr;

- (void)startAnimation;
- (void)stopAnimation;

- (void) share:(id)sender;

- (void)updateViews;
- (void) setShareProgress:(float) progress;

- (void)renderAudio;
- (void)renderVideo;
- (void)exportRingtone;
- (void)cancelRendering:(id)sender;

@end
