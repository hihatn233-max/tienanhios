#import "ESPOverlayView.h"
#import <QuartzCore/QuartzCore.h>

typedef struct { float x, y, z; } Vector3;

BOOL WorldToScreen(Vector3 worldPos, Vector3* screenPos, CGSize screenSize) {
    screenPos->x = screenSize.width / 2;
    screenPos->y = screenSize.height / 2;
    return YES; 
}

@implementation ESPOverlayView

+ (instancetype)sharedInstance {
    static ESPOverlayView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ESPOverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        instance.backgroundColor = [UIColor clearColor];
        instance.userInteractionEnabled = NO;
    });
    return instance;
}

- (void)startRendering {
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(renderLoop)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopRendering {
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self setNeedsDisplay];
}

- (void)renderLoop {
    if ([MenuView sharedInstance].espEnabled) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context || ![MenuView sharedInstance].espEnabled) return;

    NSArray *enemies = @[ @{@"worldPos": [NSValue valueWithBytes:&(Vector3){0,0,0} objCType:@encode(Vector3)]} ];
    CGContextSetLineWidth(context, 2.0);
    
    for (NSDictionary *enemy in enemies) {
        Vector3 wPos; [enemy[@"worldPos"] getValue:&wPos];
        Vector3 sPos;
        if (WorldToScreen(wPos, &sPos, self.bounds.size)) {
            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            CGRect box = CGRectMake(sPos.x - 25, sPos.y - 80, 50, 100);
            CGContextStrokeRect(context, box);
            CGContextMoveToPoint(context, self.bounds.size.width / 2, self.bounds.size.height);
            CGContextAddLineToPoint(context, sPos.x, sPos.y + 20);
            CGContextStrokePath(context);
            UIFont *font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
            NSDictionary *attrs = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]};
            [@"Enemy | 67m" drawAtPoint:CGPointMake(sPos.x - 30, sPos.y - 100) withAttributes:attrs];
        }
    }
}
@end
