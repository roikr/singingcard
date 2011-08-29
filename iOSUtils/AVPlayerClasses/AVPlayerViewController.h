//
//  AVPlayerViewController.h
//  SingingCard
//
//  Created by Roee Kremer on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AVPlayer;
@class AVPlayerItem;

@interface AVPlayerViewController : UIViewController {
	
	AVPlayer* player;
	
		
}

@property (nonatomic, retain) AVPlayer *player;

-(void)loadAssetFromURL:(NSURL *)fileURL;
-(IBAction)skip:(id)sender;
 

@end
