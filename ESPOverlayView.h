#import <UIKit/UIKit.h>

@interface ESPOverlayView : UIView
@property (nonatomic, strong) CADisplayLink *displayLink;
+ (instancetype)sharedInstance;
- (void)startRendering;
- (void)stopRendering;
@end
