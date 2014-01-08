//
//  CustomVideoOverlapper.h
//  SimpleVideoFileFilter
//
//  Created by Graycell on 07/01/14.
//  Copyright (c) 2014 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomMoviePlayer.h"

@interface CustomVideoOverlapper : NSObject {
    AVMutableComposition *composition;
    AVMutableVideoComposition *videoComposition;
    AVSynchronizedLayer *synchLayer;
}
@property(nonatomic, strong) UIViewController *controller;
- (id)initWithController:(UIViewController *)controller;

- (void)videoOverlappingMethodWithVideoOneURL:(NSURL *)videoOneURL andVideoTwoURL:(NSURL *)videoTwoURL;

-(void)prepareComposition;
@end
