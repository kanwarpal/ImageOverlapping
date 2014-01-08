//
//  CustomMoviePlayer.h
//  SimpleVideoFileFilter
//
//  Created by Graycell on 08/01/14.
//  Copyright (c) 2014 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CustomMoviePlayer : NSObject

@property(nonatomic, strong) UIViewController *controller;
@property(nonatomic, strong) NSURL *url;

- (id)initWithController:(UIViewController *)controller andURLForMovie:(NSURL *)url;
- (void)playVideo;

@end
