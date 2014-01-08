//
//  CustomMoviePlayer.m
//  SimpleVideoFileFilter
//
//  Created by Graycell on 08/01/14.
//  Copyright (c) 2014 Cell Phone. All rights reserved.
//

#import "CustomMoviePlayer.h"

@implementation CustomMoviePlayer

@synthesize url = _url;
@synthesize controller = _controller;
#pragma mark - Initialisation
- (id)initWithController:(UIViewController *)controller andURLForMovie:(NSURL *)url {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.url = url;
    }
    return self;
}

- (void)playVideo {
    
    MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]
                                             initWithContentURL:self.url];
    [self.controller presentMoviePlayerViewControllerAnimated:theMovie];
    
    // Register for the playback finished notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:theMovie];
}

#pragma mark - Notification

- (void)myMovieFinishedCallback:(NSNotification *)notification {
    
    [self.controller dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerViewController *movie = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:movie];
}

@end
