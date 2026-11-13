#import "MenuView.h"
#import "ESPOverlayView.h"

@implementation MenuView

+ (instancetype)sharedInstance {
    static MenuView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MenuView alloc] init];
    });
    return instance;
}

- (void)showMenu {
    self.overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    self.overlayWindow.backgroundColor = [UIColor clearColor];
    self.overlayWindow.rootViewController = [UIViewController new];
    self.overlayWindow.hidden = NO;

    UIButton *floatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    floatBtn.frame = CGRectMake(50, 100, 50, 50);
    floatBtn.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:0.8];
    [floatBtn setTitle:@"P" forState:UIControlStateNormal];
    floatBtn.layer.cornerRadius = 25;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [floatBtn addGestureRecognizer:pan];
    [floatBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self.overlayWindow.rootViewController.view addSubview:floatBtn];

    UIView *menuContainer = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 300, 400)];
    menuContainer.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    menuContainer.layer.cornerRadius = 15;
    menuContainer.tag = 999;
    menuContainer.hidden = YES;
    
    UISwitch *aimSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 50, 50, 30)];
    [aimSwitch addTarget:self action:@selector(aimToggle:) forControlEvents:UIControlEventValueChanged];
    [menuContainer addSubview:aimSwitch];
    
    UILabel *aimLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 150, 30)];
    aimLabel.text = @"Silent Aim";
    aimLabel.textColor = [UIColor whiteColor];
    [menuContainer addSubview:aimLabel];
    
    UISwitch *espSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 100, 50, 30)];
    [espSwitch addTarget:self action:@selector(espToggle:) forControlEvents:UIControlEventValueChanged];
    [menuContainer addSubview:espSwitch];
    
    UILabel *espLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 150, 30)];
    espLabel.text = @"ESP Lines";
    espLabel.textColor = [UIColor whiteColor];
    [menuContainer addSubview:espLabel];

    [self.overlayWindow.rootViewController.view addSubview:menuContainer];
    
    // Add ESP View to overlay
    [[ESPOverlayView sharedInstance] startRendering];
    [self.overlayWindow.rootViewController.view insertSubview:[ESPOverlayView sharedInstance] atIndex:0];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.overlayWindow];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.overlayWindow];
}

- (void)toggleMenu {
    UIView *menu = [self.overlayWindow.rootViewController.view viewWithTag:999];
    menu.hidden = !menu.hidden;
}

- (void)aimToggle:(UISwitch *)sender {
    self.aimbotEnabled = sender.isOn;
}

- (void)espToggle:(UISwitch *)sender {
    self.espEnabled = sender.isOn;
    if (sender.isOn) [[ESPOverlayView sharedInstance] startRendering];
    else [[ESPOverlayView sharedInstance] stopRendering];
}

@end
