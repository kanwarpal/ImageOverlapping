//
//  CustomVideoOverlapper.m
//  SimpleVideoFileFilter
//
//  Created by Graycell on 07/01/14.
//  Copyright (c) 2014 Cell Phone. All rights reserved.
//

#import "CustomVideoOverlapper.h"
@implementation CustomVideoOverlapper

@synthesize controller = _controller;
#pragma mark - Initialisation
- (id)initWithController:(UIViewController *)controller {
    
    self = [super init];
    if (self) {
        self.controller = controller;
    }
    return self;
}

-(void)prepareComposition
{
    composition = [AVMutableComposition composition];
    videoComposition = [AVMutableVideoComposition videoComposition];
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"videobackground1" ofType:@"mp4"]];
    
    AVAsset * videoAsset1 = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clipcanvas" ofType:@"mp4"]] options:nil];;
    
   // NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"kids4" ofType:@"mp4"]];
    AVAsset *videoAsset2 = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Test_1" ofType:@"mp4"]] options:nil];;
    
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrack2 = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(12, 600)) ofTrack:[[videoAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [videoTrack2 insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(12, 600)) ofTrack:[[videoAsset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(12, 600)) ofTrack:[[videoAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    videoComposition.renderSize = composition.naturalSize;
    videoComposition.frameDuration = CMTimeMake(1, 25);
    NSLog(@"composition duration %f", CMTimeGetSeconds( composition.duration) );
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInstruction setTransform: videoTrack.preferredTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionLayerInstruction *videoLayer2Instruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack2];
    [videoLayer2Instruction setOpacity:1.0 atTime:kCMTimeZero];
    [videoLayer2Instruction setTransform:CGAffineTransformTranslate(CGAffineTransformMakeScale(0.5, 0.5), 320, 180) atTime:kCMTimeZero ];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(12, 600));
    instruction.layerInstructions = [NSArray arrayWithObjects:videoLayer2Instruction, layerInstruction, nil];
    
    videoComposition.instructions = [NSArray arrayWithObjects: instruction,  nil];
    [self renderComposition];
}

-(void)renderComposition
{
    [self exportComposition:composition withVideoComposition:videoComposition];
}

-(void)exportComposition:(AVComposition*)composition1 withVideoComposition: (AVVideoComposition*) videoComposition1
{
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //[self.view addSubview:activityIndicator];
    //activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
   // [activityIndicator startAnimating];
   // [activityIndicator setHidesWhenStopped:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mov",3]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs]) {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition1
                                                                      presetName:AVAssetExportPresetLowQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    //exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComposition1;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Video created");
            //[activityIndicator stopAnimating];
            [self exportDidFinish:exporter];
            
        });
    }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session
{
    NSURL *outputURL = session.outputURL;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                    completionBlock:^(NSURL *assetURL, NSError *error){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (error) {
                                                NSLog(@"writeVideoToAssestsLibrary failed: %@", error);
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                                                                    message:[error localizedRecoverySuggestion]
                                                                                                   delegate:nil
                                                                                          cancelButtonTitle:@"OK"
                                                                                          otherButtonTitles:nil];
                                                [alertView show];
                                            }
                                            else {
                                                NSLog(@"Saved To Photos Album.. %@", assetURL);
                                                
                                                
                                            }
                                        });
                                    }];
    }
    else {
        NSLog(@"hi");
    }
}


@end
