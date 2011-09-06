//
//  ShareManager.h
//  Milgrom
//
//  Created by Roee Kremer on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FacebookUploader.h"
#import "FacebookUploadViewController.h"
#import "YouTubeUploader.h"
#import "YouTubeUploadViewController.h"
#import "RenderManager.h"


enum {
	ACTION_UPLOAD_TO_FACEBOOK,
	ACTION_UPLOAD_TO_YOUTUBE,
	ACTION_ADD_TO_LIBRARY,
	ACTION_SEND_VIA_MAIL,
	ACTION_SEND_RINGTONE,
	ACTION_CANCEL,
	ACTION_RENDER,
	ACTION_PLAY
};




@interface ShareManager : NSObject<UIActionSheetDelegate,FacebookUploaderDelegate,FacebookUploadViewControllerDelegate,YouTubeUploaderDelegate,YouTubeUploadViewControllerDelegate,MFMailComposeViewControllerDelegate,RenderManagerDelegate> {
	FacebookUploader *facebookUploader;
	YouTubeUploader *youTubeUploader;
	
	NSInteger renderedVideoVersion;
	NSInteger exportedRingtoneVersion;
	BOOL canSendMail;
	NSUInteger action;
	NSUInteger state;
	BOOL bAudioRendered;
	
	UIViewController *parentViewController;
	
	RenderManager *renderManager;
}


@property (nonatomic,retain) FacebookUploader *facebookUploader;
@property (nonatomic,retain) YouTubeUploader *youTubeUploader;
@property (readonly) BOOL isUploading;

@property (readonly) BOOL videoRendered;
@property (readonly) BOOL ringtoneExported;

@property (nonatomic,retain) UIViewController *parentViewController;
@property (nonatomic,retain) RenderManager *renderManager;

+ (ShareManager*) shareManager;

- (void)menuWithView:(UIView *)view;
- (NSString *)getSongName;
- (NSString *)getDisplayName;
- (NSString *)getVideoPath;

- (void)resetVersions;
- (void)applicationDidEnterBackground;

@end
