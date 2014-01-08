#import <UIKit/UIKit.h>

//@class RippleViewController;
@class SimpleVideoFileFilterViewController;

@interface SimpleVideoFileFilterAppDelegate : UIResponder <UIApplicationDelegate>
{
    SimpleVideoFileFilterViewController *rootViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SimpleVideoFileFilterViewController *viewController;
@end
