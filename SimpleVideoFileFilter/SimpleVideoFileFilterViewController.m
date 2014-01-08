#import "SimpleVideoFileFilterViewController.h"

@implementation SimpleVideoFileFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Handlers

-(IBAction)videoOneButtonTapped:(id)sender {
    isVideoOne = YES;
    [self browseMediaLibraryFromViewController:self withDelegate:self];
}

- (IBAction)videoTwoButtonTapped:(id)sender {
    isVideoOne = NO;
    [self browseMediaLibraryFromViewController:self withDelegate:self];
}

- (BOOL)browseMediaLibraryFromViewController:(UIViewController *)controller withDelegate:(id)delegate {
    
    //Validation
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        
        return NO;
    }
    //Create image picker
    _picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;
    [self presentViewController:self.picker animated:YES completion:nil];
    
    return YES;
}


#pragma mark - ImagePicker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //dismiss ImagePickerController
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    //handle Movie capture
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        NSLog(@"Matching Success");
        if (isVideoOne){
            
            NSLog(@"Video One Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video One Loaded"
                                                            message:@"Video One Loaded"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //capture selected videoOneURL
            self.videoOneURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSLog(@"videoOneURL = %@",self.videoOneURL);
            
        } else {
            
            NSLog(@"Video two Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Two Loaded"
                                                            message:@"Video Two Loaded"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //capture selected videoTwoURL
            self.videoTwoURL =[info objectForKey:UIImagePickerControllerMediaURL];
            NSLog(@"videoTwoURL = %@",self.videoTwoURL);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //dismiss ImagePickerController
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)overlapVideoButtonTapped:(id)sender {
    videoOverlapper = [[CustomVideoOverlapper alloc] initWithController:self];
    
    //Pass Two video URL's we saved previously for merging process
    [videoOverlapper prepareComposition];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *videoTrackOne = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrackTwo = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"tempVideo" ofType:@".mov"];
    NSLog(@"pathString = %@",pathString);
    AVURLAsset * urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:pathString] options:nil];
    
    //AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    [videoTrackOne insertTimeRange:CMTimeRangeMake(kCMTimeZero, urlAsset.duration) ofTrack:[[urlAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
     
    [videoTrackTwo insertTimeRange:CMTimeRangeMake(kCMTimeZero, urlAsset.duration) ofTrack:[[urlAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
     
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction    videoCompositionInstruction];
    AVMutableVideoCompositionLayerInstruction *firstLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrackOne];
    AVMutableVideoCompositionLayerInstruction *secondLayerInstruction = [AVMutableVideoCompositionLayerInstruction  videoCompositionLayerInstructionWithAssetTrack:videoTrackTwo];
     
    CGAffineTransform Scale = CGAffineTransformMakeScale(0.2f,0.2f);
    CGAffineTransform Move = CGAffineTransformMakeTranslation(230,230);
     
    [firstLayerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
     
    CGAffineTransform SecondScale = CGAffineTransformMakeScale(1.2f,1.5f);
    CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
    [secondLayerInstruction setTransform:CGAffineTransformConcat(SecondScale,SecondMove) atTime:kCMTimeZero];
     
    mainInstruction.layerInstructions =  @[firstLayerInstruction, secondLayerInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,  CMTimeAdd(urlAsset.duration, urlAsset.duration));
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[mainInstruction];
    videoComposition.frameDuration = CMTimeMake(1, 24);
    videoComposition.renderSize = urlAsset.naturalSize;
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updatePixelWidth:(id)sender
{
//    [(GPUImageUnsharpMaskFilter *)filter setIntensity:[(UISlider *)sender value]];
    [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
}

@end
