#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "CustomVideoOverlapper.h"

@interface SimpleVideoFileFilterViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    GPUImageMovie *movieFile;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    CustomVideoOverlapper *videoOverlapper;
    BOOL isVideoOne;
}

@property (nonatomic, strong) IBOutlet UIButton *videoOneButton;
@property (nonatomic, strong) IBOutlet UIButton *videoTwoButton;
@property (nonatomic, strong) IBOutlet UIButton *overlapVideoButton;
@property (nonatomic, strong) NSURL *videoOneURL;
@property (nonatomic, strong) NSURL *videoTwoURL;
@property (nonatomic, strong) UIImagePickerController *picker;

- (IBAction)videoOneButtonTapped:(id)sender;
- (IBAction)videoTwoButtonTapped:(id)sender;
- (IBAction)overlapVideoButtonTapped:(id)sender;
- (IBAction)updatePixelWidth:(id)sender;

@end