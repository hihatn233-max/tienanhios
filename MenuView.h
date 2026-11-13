#import <UIKit/UIKit.h>

@interface MenuView : NSObject
@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, assign) BOOL aimbotEnabled;
@property (nonatomic, assign) BOOL espEnabled;
+ (instancetype)sharedInstance;
- (void)showMenu;
@end
